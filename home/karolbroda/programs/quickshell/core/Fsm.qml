import QtQuick

QtObject {
    id: root

    required property string initial
    required property var transitions

    readonly property string state: _state

    signal entered(string state, string from)

    property string _state: initial

    function is(...states): bool {
        return states.includes(root._state)
    }

    function can(to: string): bool {
        return (root.transitions[root._state] ?? []).includes(to)
    }

    function go(to: string): bool {
        if (!root.can(to)) {
            console.warn("[Fsm] illegal transition", root._state, "->", to)
            return false
        }
        const from = root._state
        root._state = to
        root.entered(to, from)
        return true
    }

    function reset(): void {
        const from = root._state
        root._state = root.initial
        if (from !== root.initial) root.entered(root.initial, from)
    }
}
