import Quickshell
import Quickshell.Services.Pam
import qs.core

Scope {
    id: root

    signal unlocked()

    property string password: ""
    readonly property bool isAuthenticating: auth.is("authenticating")
    readonly property bool authFailed: auth.is("failed")
    property string errorMessage: ""

    property string _submittedPassword: ""

    function setPassword(value: string): void {
        if (!root.isAuthenticating) root.password = value
    }

    function submitPassword(): void {
        if (root.password === "" || root.isAuthenticating) return
        root._submittedPassword = root.password
        root.errorMessage = ""
        auth.go("authenticating")
        if (!pam.start()) root._fail("authentication error")
    }

    function clearPassword(): void {
        auth.reset()
        pam.abort()
        root.password = ""
        root._submittedPassword = ""
        root.errorMessage = ""
    }

    function _fail(message: string): void {
        if (!root.isAuthenticating) return
        root.password = ""
        root._submittedPassword = ""
        root.errorMessage = message
        auth.go("failed")
    }

    Fsm {
        id: auth
        initial: "idle"
        transitions: ({
            idle: ["authenticating"],
            authenticating: ["idle", "failed"],
            failed: ["authenticating"]
        })
    }

    PamContext {
        id: pam
        config: "quickshell-lock"
        user: Quickshell.env("USER") ?? ""

        onPamMessage: {
            if (root.isAuthenticating && pam.responseRequired) pam.respond(root._submittedPassword)
        }
        onError: root._fail("authentication error")
        onCompleted: result => {
            if (!root.isAuthenticating) return
            if (result === PamResult.Success) {
                root.password = ""
                root._submittedPassword = ""
                auth.go("idle")
                root.unlocked()
            } else {
                root._fail("incorrect")
            }
        }
    }
}
