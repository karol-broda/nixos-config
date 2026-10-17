pragma Singleton

import Quickshell
import QtQuick
import qs.core

Singleton {
    id: root

    readonly property bool loaded: _weather.loaded
    readonly property string location: _place.city
    readonly property string temperature: _weather.temperature
    readonly property string condition: _weather.condition
    readonly property string icon: _weather.icon
    readonly property var forecast: _weather.forecast

    property var _weather: ({ loaded: false, temperature: "", condition: "", icon: "sun", forecast: null })
    property var _place: ({ city: "", coordinates: "" })
    property int _failures: 0

    readonly property var weatherIcons: ({
        "113": "sun",
        "116": "cloud-sun",
        "119": "cloud",
        "122": "cloud",
        "143": "cloud-fog",
        "176": "cloud-rain",
        "179": "cloud-snow",
        "182": "cloud-snow",
        "185": "cloud-snow",
        "200": "cloud-lightning",
        "227": "cloud-snow",
        "230": "cloud-snow",
        "248": "cloud-fog",
        "260": "cloud-fog",
        "263": "cloud-rain",
        "266": "cloud-rain",
        "281": "cloud-snow",
        "284": "cloud-snow",
        "293": "cloud-rain",
        "296": "cloud-rain",
        "299": "cloud-rain",
        "302": "cloud-rain",
        "305": "cloud-rain",
        "308": "cloud-rain",
        "311": "cloud-snow",
        "314": "cloud-snow",
        "317": "cloud-snow",
        "320": "cloud-snow",
        "323": "cloud-snow",
        "326": "cloud-snow",
        "329": "cloud-snow",
        "332": "cloud-snow",
        "335": "cloud-snow",
        "338": "cloud-snow",
        "350": "cloud-snow",
        "353": "cloud-rain",
        "356": "cloud-rain",
        "359": "cloud-rain",
        "362": "cloud-snow",
        "365": "cloud-snow",
        "368": "cloud-snow",
        "371": "cloud-snow",
        "374": "cloud-snow",
        "377": "cloud-snow",
        "386": "cloud-lightning",
        "389": "cloud-lightning",
        "392": "cloud-lightning",
        "395": "cloud-snow"
    })

    function reload(): void {
        if (!flow.is("idle")) return
        root._start()
    }

    function _start(): void {
        flow.go(root._place.coordinates ? "fetching" : "locating")
    }

    function _fail(): void {
        root._failures = Math.min(3, root._failures + 1)
        flow.go("backoff")
    }

    Fsm {
        id: flow
        initial: "idle"
        transitions: ({
            idle: ["locating", "fetching"],
            locating: ["fetching", "backoff"],
            fetching: ["idle", "backoff"],
            backoff: ["idle", "locating", "fetching"]
        })
        onEntered: state => {
            if (state === "locating") {
                job.run(["curl", "-sf", "--max-time", "15", "https://ipinfo.io/json"], state)
            } else if (state === "fetching") {
                const url = "https://wttr.in/" + encodeURIComponent(root._place.coordinates) + "?format=j1"
                job.run(["curl", "-sf", "--max-time", "15", url], state)
            } else if (state === "backoff") {
                backoff.interval = 30000 * Math.pow(2, root._failures - 1)
                backoff.restart()
            }
        }
    }

    Job {
        id: job
        environment: Env.withProfilePath
        timeout: 16000
        onFinished: (tag, output, exitCode) => {
            if (tag !== flow.state) return
            if (exitCode !== 0) {
                root._fail()
                return
            }
            try {
                const data = JSON.parse(output)
                if (tag === "locating") {
                    if (typeof data?.loc !== "string" || !/^-?\d+(?:\.\d+)?,-?\d+(?:\.\d+)?$/.test(data.loc)) {
                        root._fail()
                        return
                    }
                    root._place = { city: String(data.city ?? ""), coordinates: data.loc }
                    flow.go("fetching")
                } else {
                    const current = data?.current_condition?.[0]
                    if (current?.temp_C == null) {
                        root._fail()
                        return
                    }
                    root._weather = {
                        loaded: true,
                        temperature: String(current.temp_C),
                        condition: String(current.weatherDesc?.[0]?.value ?? ""),
                        icon: root.weatherIcons[String(current.weatherCode ?? "")] ?? "sun",
                        forecast: data.weather ?? null
                    }
                    root._failures = 0
                    flow.go("idle")
                }
            } catch (e) {
                root._fail()
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        onTriggered: root.reload()
    }

    Timer {
        id: backoff
        onTriggered: {
            if (root._failures >= 3) flow.go("idle")
            else root._start()
        }
    }

    Timer {
        interval: 900000
        running: true
        repeat: true
        onTriggered: root.reload()
    }
}
