pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property string user: Quickshell.env("USER") ?? ""

    readonly property var withProfilePath: ({
        PATH: ["/run/current-system/sw/bin", "/etc/profiles/per-user/" + root.user + "/bin", Quickshell.env("PATH") ?? ""]
            .filter(p => p !== "")
            .join(":")
    })

    function launch(command: var): void {
        Quickshell.execDetached({ command: command, environment: root.withProfilePath })
    }
}
