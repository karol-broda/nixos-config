pragma Singleton

import Quickshell
import QtQuick
import qs.services

Singleton {
    id: root

    property bool loaded: false
    property string location: ""
    property string temperature: ""
    property string condition: ""
    property string icon: "sun"

    property var cc: null
    property var forecast: null

    property string cachedLoc: ""
    property bool locationFetched: false

    property bool fetching: false
    property int retryCount: 0
    readonly property int maxRetries: 3
    readonly property int baseRetryDelayMs: 30000

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

    function getWeatherIcon(code) {
        if (code === null || code === undefined) return "sun"
        const codeStr = code.toString()
        if (root.weatherIcons[codeStr] !== undefined) {
            return root.weatherIcons[codeStr]
        }
        return "sun"
    }

    function scheduleRetry(): void {
        if (root.retryCount >= root.maxRetries) {
            console.warn("[WEATHER] giving up after " + root.maxRetries + " retries")
            root.fetching = false
            root.retryCount = 0
            return
        }

        const delay = root.baseRetryDelayMs * Math.pow(2, root.retryCount)
        root.retryCount += 1
        console.log("[WEATHER] retry " + root.retryCount + "/" + root.maxRetries + " in " + (delay / 1000) + "s")
        retryTimer.interval = delay
        retryTimer.restart()
    }

    function reload(): void {
        if (root.fetching) return

        root.fetching = true
        root.retryCount = 0

        if (root.locationFetched && root.cachedLoc !== "") {
            fetchWeather(root.cachedLoc)
            return
        }

        Requests.get("https://ipinfo.io/json", function(text) {
            try {
                const parsed = JSON.parse(text)
                if (parsed !== null && parsed !== undefined && parsed.city !== null && parsed.city !== undefined) {
                    root.location = parsed.city
                    const loc = parsed.loc !== null && parsed.loc !== undefined ? parsed.loc : ""
                    root.cachedLoc = loc
                    root.locationFetched = true
                    fetchWeather(loc)
                }
            } catch (e) {
                console.warn("[WEATHER] failed to get location")
                root.fetching = false
            }
        }, function(_reason) {
            root.scheduleRetry()
        })
    }

    function fetchWeather(loc: string): void {
        if (loc === null || loc === undefined || loc === "") {
            root.fetching = false
            return
        }

        Requests.get("https://wttr.in/" + loc + "?format=j1", function(text) {
            root.fetching = false
            root.retryCount = 0

            try {
                const json = JSON.parse(text)
                if (json === null || json === undefined) return

                const current = json.current_condition
                if (current !== null && current !== undefined && current.length > 0) {
                    root.cc = current[0]

                    const tempC = root.cc.temp_C
                    root.temperature = tempC !== null && tempC !== undefined ? tempC : "0"

                    const weatherDesc = root.cc.weatherDesc
                    if (weatherDesc !== null && weatherDesc !== undefined && weatherDesc.length > 0) {
                        const firstDesc = weatherDesc[0]
                        root.condition = firstDesc !== null && firstDesc !== undefined && firstDesc.value !== null ? firstDesc.value : ""
                    }

                    const weatherCode = root.cc.weatherCode
                    root.icon = root.getWeatherIcon(weatherCode)
                    root.loaded = true
                }

                root.forecast = json.weather
            } catch (e) {
                console.warn("[WEATHER] failed to parse weather data")
            }
        }, function(_reason) {
            root.scheduleRetry()
        })
    }

    // delay initial fetch so the network stack has time to come up
    Timer {
        id: startupTimer
        interval: 5000
        running: true
        repeat: false
        onTriggered: root.reload()
    }

    Timer {
        id: retryTimer
        running: false
        repeat: false
        onTriggered: {
            root.fetching = false
            root.reload()
        }
    }

    Timer {
        interval: 900000
        running: true
        repeat: true
        onTriggered: root.reload()
    }
}
