import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

ShellRoot {
    id: root

    property int current: 0

    readonly property var actions: [
        { label: "Suspend",    icon: "system-suspend-symbolic",   code: Qt.Key_U, cmd: ["systemctl", "suspend"]   },
        { label: "Hibernate",  icon: "system-hibernate-symbolic", code: Qt.Key_H, cmd: ["systemctl", "hibernate"] },
        { label: "Reboot",     icon: "system-reboot-symbolic",    code: Qt.Key_R, cmd: ["systemctl", "reboot"]    },
        { label: "Shutdown",   icon: "system-shutdown-symbolic",  code: Qt.Key_S, cmd: ["systemctl", "poweroff"]  }
    ]

    function run(i) {
        Quickshell.execDetached(actions[i].cmd);
        Qt.quit();
    }

    // Palette
    readonly property color cBg:     "#8811111b"
    readonly property color cTile:   Pywal.surface
    readonly property color cBorder: Pywal.color1
    readonly property color cText:   Pywal.cursor
    readonly property color cDim:    Pywal.onSurfaceMuted
    readonly property color cAccent: Pywal.secondary

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData

            BackgroundEffect.blurRegion: Region { item: panel.contentItem }

            anchors { top: true; bottom: true; left: true; right: true }
            color: root.cBg
            exclusionMode: ExclusionMode.Ignore

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            WlrLayershell.namespace: "logout-menu"

            // Click outside tiles to close
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }

            Item {
                anchors.fill: parent
                focus: true

                Keys.onPressed: event => {
                    const n = root.actions.length;
                    switch (event.key) {
                    case Qt.Key_Escape:
                        Qt.quit();
                        return;
                    case Qt.Key_Left:
                    case Qt.Key_Backtab:
                        root.current = (root.current + n - 1) % n;
                        return;
                    case Qt.Key_Right:
                    case Qt.Key_Tab:
                        root.current = (root.current + 1) % n;
                        return;
                    case Qt.Key_Return:
                    case Qt.Key_Enter:
                        root.run(root.current);
                        return;
                    }
                    for (let i = 0; i < n; i++) {
                        if (event.key === root.actions[i].code) {
                            root.run(i);
                            return;
                        }
                    }
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 28

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 16

                        Repeater {
                            model: root.actions

                            Rectangle {
                                id: tile
                                required property var modelData
                                required property int index

                                readonly property bool active: root.current === index
                                readonly property color accent: root.cAccent

                                width: 200
                                height: 200
                                radius: 18
                                color: active ? Qt.rgba(accent.r, accent.g, accent.b, 0.15) : root.cTile
                                border.width: 2
                                border.color: active ? accent : root.cBorder
                                scale: active ? 1.06 : 1.0

                                Behavior on scale        { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                                Behavior on color        { ColorAnimation  { duration: 120 } }
                                Behavior on border.color { ColorAnimation  { duration: 120 } }

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 14

                                    IconImage {
                                        source: Quickshell.iconPath(tile.modelData.icon)
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        implicitSize: 64
                                    }
                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: tile.modelData.label
                                        color: tile.active ? root.cText : root.cDim
                                        font.pixelSize: 15
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: root.current = tile.index
                                    onClicked: root.run(tile.index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
