pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property int defaultTimeoutMs: 15000

    function get(url: string, callback: var, errorCallback: var): void {
        const xhr = new XMLHttpRequest()
        var completed = false

        const finish = () => {
            if (completed) return
            completed = true
            xhr.onreadystatechange = null
            xhr.onerror = null
            xhr.ontimeout = null
        }

        const handleError = (reason) => {
            if (completed) return
            console.warn("[REQUESTS] GET request to " + url + " failed: " + reason)
            finish()
            if (errorCallback !== null && errorCallback !== undefined) {
                errorCallback(reason)
            }
        }

        xhr.open("GET", url, true)
        xhr.timeout = root.defaultTimeoutMs

        xhr.onreadystatechange = () => {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    finish()
                    callback(xhr.responseText)
                } else {
                    handleError("status " + xhr.status)
                }
            }
        }

        xhr.onerror = () => {
            handleError("network error")
        }

        xhr.ontimeout = () => {
            handleError("timeout after " + root.defaultTimeoutMs + "ms")
        }

        xhr.send()
    }
}
