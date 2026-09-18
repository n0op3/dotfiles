import "."

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: blurred
            color: "transparent"
            aboveWindows: true
            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 1

            property var modelData
            screen: modelData

            anchors {
                bottom: true
                top: true
                left: true
                right: true
            }

            BackgroundEffect.blurRegion: Region { item: blurred.contentItem }
        }
    }

    PanelWindow {
        id: root
        color: "transparent"

        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        aboveWindows: true
        exclusionMode: ExclusionMode.Ignore
        exclusiveZone: 1

        implicitWidth: 1000
        implicitHeight: 1000

        Item {
            id: content
            anchors.fill: parent
            focus: true

            property int action: Actions.Action.None

            GridLayout {
                id: grid
                anchors.centerIn: parent
                columns: 3
                rowSpacing: 10
                columnSpacing: 10

                PowerButton { Layout.column: 1; Layout.row: 0; label: "Shutdown"; onClicked: action = Actions.Action.Shutdown }
                PowerButton { Layout.column: 0; Layout.row: 1; label: "Suspend";  onClicked: action = Actions.Action.Suspend }

                PowerButton { Layout.column: 2; Layout.row: 1; label: "Reboot";   onClicked: action = Actions.Action.Reboot }
                PowerButton { Layout.column: 1; Layout.row: 2; label: "Hibernate";onClicked: action = Actions.Action.Hibernate }
            }

            Keys.onPressed: function(event) {
                if (event.key == Qt.Key_Escape) {
                    if (action == Actions.Action.None) {
                        Qt.quit()
                    } else {
                        action = Actions.Action.None
                    }
                }
                event.accepted = true
            }
        }
    }
}
