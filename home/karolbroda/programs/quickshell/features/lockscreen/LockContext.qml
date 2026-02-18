import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root

    signal unlocked()

    property string password: ""
    property bool isAuthenticating: false
    property bool authFailed: false
    property string errorMessage: ""

    PamContext {
        id: pam
        config: "quickshell-lock"
        user: Quickshell.env("USER") || ""

        onPamMessage: function(message) {
            if (pam.responseRequired) {
                pam.respond(root.password)
            }
        }

        onError: function(error) {
            root.isAuthenticating = false
            root.authFailed = true
            root.errorMessage = "authentication error"
            root.password = ""
        }

        onCompleted: function(result) {
            root.isAuthenticating = false

            if (result === PamResult.Success) {
                root.unlocked()
            } else {
                root.authFailed = true
                root.errorMessage = "incorrect"
                root.password = ""
            }
        }
    }

    function submitPassword() {
        if (password === "" || isAuthenticating) {
            return
        }

        isAuthenticating = true
        authFailed = false
        errorMessage = ""
        pam.start()
    }

    function clearPassword() {
        password = ""
        authFailed = false
        errorMessage = ""
    }
}
