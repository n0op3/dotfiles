import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick

ShellRoot {
    WlSessionLock {
        id: lock
        locked: true

        WlSessionLockSurface {
            color: "black"

            PamContext {
                id: pam
                onPamMessage: {
                    if (responseRequired) {
                        pam.respond(passwordField.text)
                        passwordField.text = ""
                    }
                }
                onCompleted: (result) => {
                    if (result === PamResult.Success) lock.locked = false
                    else passwordField.text = ""
                }
            }

            TextInput {
                id: passwordField
                anchors.centerIn: parent
                echoMode: TextInput.Password
                onAccepted: pam.start()
            }
        }
    }
}
