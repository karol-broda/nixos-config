pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import qs.core

Singleton {
    id: root

    property int users: 0

    readonly property real cpuPerc: _cpu.percentage
    readonly property real cpuTemp: _temperatures.cpu
    readonly property string gpuType: _gpu.type
    readonly property real gpuPerc: _gpu.percentage
    readonly property real gpuTemp: gpuType === "NVIDIA" ? _gpu.temperature : _temperatures.gpu
    readonly property real memUsed: _memory.used
    readonly property real memTotal: _memory.total
    readonly property real memPerc: memTotal > 0 ? Math.max(0, Math.min(1, memUsed / memTotal)) : 0
    readonly property real storageUsed: _storage.used
    readonly property real storageTotal: _storage.total
    readonly property real storagePerc: storageTotal > 0 ? Math.max(0, Math.min(1, storageUsed / storageTotal)) : 0

    property var _cpu: ({ primed: false, idle: 0, total: 0, percentage: 0 })
    property var _memory: ({ used: 0, total: 0 })
    property var _storage: ({ used: 0, total: 0 })
    property var _gpu: ({ type: "NONE", percentage: 0, temperature: 0 })
    property var _temperatures: ({ cpu: 0, gpu: 0 })

    function formatKib(kib: real): var {
        if (kib >= 1024 ** 3) return { value: kib / 1024 ** 3, unit: "TiB" }
        if (kib >= 1024 ** 2) return { value: kib / 1024 ** 2, unit: "GiB" }
        if (kib >= 1024) return { value: kib / 1024, unit: "MiB" }
        return { value: kib, unit: "KiB" }
    }

    function _poll(): void {
        stat.reload()
        meminfo.reload()
        storage.poll(["df", "-kP"], null)
        sensors.poll(["sensors"], null)
        root._pollGpu()
    }

    function _pollGpu(): void {
        if (root.gpuType === "NVIDIA") {
            gpuUsage.poll(["nvidia-smi", "--query-gpu=utilization.gpu,temperature.gpu", "--format=csv,noheader,nounits"], "NVIDIA")
        } else if (root.gpuType === "GENERIC") {
            gpuUsage.poll(["sh", "-c", "cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null"], "GENERIC")
        }
    }

    onUsersChanged: {
        if (root.users > 0) {
            if (!poller.running) {
                root._cpu = { primed: false, idle: 0, total: 0, percentage: 0 }
                gpuTypeCheck.poll(["sh", "-c", "if command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi -L >/dev/null 2>&1; then echo NVIDIA; elif test -r /sys/class/drm/card0/device/gpu_busy_percent || ls /sys/class/drm/card*/device/gpu_busy_percent >/dev/null 2>&1; then echo GENERIC; else echo NONE; fi"], null)
                root._poll()
                poller.start()
            }
        } else {
            poller.stop()
            gpuTypeCheck.cancel()
            gpuUsage.cancel()
            storage.cancel()
            sensors.cancel()
            root._cpu = { primed: false, idle: 0, total: 0, percentage: 0 }
        }
    }

    Timer {
        id: poller
        interval: 5000
        repeat: true
        onTriggered: root._poll()
    }

    FileView {
        id: stat
        path: "/proc/stat"
        onLoaded: {
            if (root.users <= 0) return
            const match = text().match(/^cpu\s+(.+)$/m)
            if (!match) return
            const counters = match[1].trim().split(/\s+/).slice(0, 8).map(n => Number(n))
            if (counters.length < 4 || counters.some(n => !isFinite(n))) return
            const total = counters.reduce((a, b) => a + b, 0)
            const idle = counters[3] + (counters[4] ?? 0)
            const delta = total - root._cpu.total
            const percentage = root._cpu.primed && delta > 0 ? 1 - (idle - root._cpu.idle) / delta : 0
            root._cpu = { primed: true, idle: idle, total: total, percentage: Math.max(0, Math.min(1, percentage)) }
        }
    }

    FileView {
        id: meminfo
        path: "/proc/meminfo"
        onLoaded: {
            if (root.users <= 0) return
            const data = text()
            const total = Number(data.match(/^MemTotal:\s*(\d+)/m)?.[1] ?? 0)
            const available = Number(data.match(/^MemAvailable:\s*(\d+)/m)?.[1] ?? total)
            root._memory = { total: total, used: Math.max(0, total - available) }
        }
    }

    Job {
        id: storage
        environment: Object.assign({}, Env.withProfilePath, { LC_ALL: "C" })
        timeout: 4000
        onFinished: (tag, output, exitCode) => {
            if (root.users <= 0 || exitCode !== 0) return
            const devices = new Map()
            for (const line of output.trim().split("\n")) {
                const parts = line.trim().split(/\s+/)
                if (!parts[0].startsWith("/dev/") || parts.length < 4) continue
                const used = Number(parts[2])
                const available = Number(parts[3])
                if (!isFinite(used) || !isFinite(available)) continue
                const previous = devices.get(parts[0])
                if (!previous || used + available > previous.total) devices.set(parts[0], { used: used, total: used + available })
            }
            let used = 0
            let total = 0
            for (const device of devices.values()) {
                used += device.used
                total += device.total
            }
            root._storage = { used: used, total: total }
        }
    }

    Job {
        id: gpuTypeCheck
        environment: Env.withProfilePath
        timeout: 4000
        onFinished: (tag, output, exitCode) => {
            if (root.users <= 0) return
            const type = output.trim()
            root._gpu = { type: exitCode === 0 && ["NVIDIA", "GENERIC"].includes(type) ? type : "NONE", percentage: 0, temperature: 0 }
            root._pollGpu()
        }
    }

    Job {
        id: gpuUsage
        environment: Env.withProfilePath
        timeout: 4000
        onFinished: (tag, output, exitCode) => {
            if (root.users <= 0 || tag !== root.gpuType) return
            const rows = exitCode === 0 ? output.trim().split("\n").filter(line => line.trim() !== "") : []
            const percentages = []
            const temperatures = []
            for (const row of rows) {
                const parts = row.split(",")
                const percentage = Number(parts[0])
                if (isFinite(percentage)) percentages.push(percentage)
                const temperature = parts.length > 1 ? Number(parts[1]) : NaN
                if (isFinite(temperature)) temperatures.push(temperature)
            }
            const percentage = percentages.length ? percentages.reduce((a, b) => a + b, 0) / percentages.length / 100 : 0
            const temperature = temperatures.length ? temperatures.reduce((a, b) => a + b, 0) / temperatures.length : 0
            root._gpu = { type: tag, percentage: Math.max(0, Math.min(1, percentage)), temperature: temperature }
        }
    }

    Job {
        id: sensors
        environment: Object.assign({}, Env.withProfilePath, { LANG: "C", LC_ALL: "C" })
        timeout: 4000
        onFinished: (tag, output, exitCode) => {
            if (root.users <= 0) return
            const text = exitCode === 0 ? output : ""
            const cpu = text.match(/(?:Package id \d+|Tdie):\s*([+-]?[\d.]+)[° ]C/) ?? text.match(/Tctl:\s*([+-]?[\d.]+)[° ]C/)
            let eligible = false
            const temperatures = []
            for (const line of text.split("\n")) {
                if (/^\S/.test(line) && !line.includes(":")) eligible = line.startsWith("amdgpu-")
                if (line.trim() === "") eligible = false
                if (!eligible) continue
                const match = line.match(/^(?:temp\d+|GPU core|edge|junction|mem):\s*\+?([\d.]+)[° ]C/)
                if (match && isFinite(Number(match[1]))) temperatures.push(Number(match[1]))
            }
            root._temperatures = {
                cpu: Number(cpu?.[1] ?? 0) || 0,
                gpu: temperatures.length ? temperatures.reduce((a, b) => a + b, 0) / temperatures.length : 0
            }
        }
    }
}
