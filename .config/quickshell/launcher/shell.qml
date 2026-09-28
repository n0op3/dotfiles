import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

ShellRoot {
    id: root
    property bool open: true

    IpcHandler {
        target: "launcher"
        function toggle(): void { root.open = !root.open }
    }

    PanelWindow {
        id: win
        visible: root.open
        color: "transparent"
        implicitWidth: 500
        implicitHeight: 400
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        onVisibleChanged: if (visible) {
            search.text = ""
            search.forceActiveFocus()
        }

        function launch() {
            if (list.currentItem) {
                list.currentItem.modelData.execute()
                root.open = false
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: "#1e1e2e"
            border.color: "#89b4fa"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                TextInput {
                    id: search
                    Layout.fillWidth: true
                    color: "#cdd6f4"
                    font.pixelSize: 18
                    onTextChanged: list.currentIndex = 0
                    Keys.onEscapePressed: root.open = false
                    Keys.onDownPressed: list.incrementCurrentIndex()
                    Keys.onUpPressed: list.decrementCurrentIndex()
                    Keys.onReturnPressed: win.launch()
                }

                ListView {
                    id: list
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    model: ScriptModel {
                        values: DesktopEntries.applications.values
                            .filter(e => !e.noDisplay
                                && e.name.toLowerCase().includes(search.text.toLowerCase()))
                            .sort((a, b) => a.name.localeCompare(b.name))
                    }

                    delegate: Rectangle {
                        id: item
                        required property var modelData
                        required property int index
                        width: list.width
                        height: 36
                        radius: 6
                        color: ListView.isCurrentItem ? "#313244" : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            spacing: 10

                            IconImage {
                                implicitSize: 24
                                source: Quickshell.iconPath(item.modelData.icon)
                            }
                            Text {
                                Layout.fillWidth: true
                                text: item.modelData.name
                                color: "#cdd6f4"
                                font.pixelSize: 14
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: { list.currentIndex = item.index; win.launch() }
                        }
                    }
                }
            }
        }
    }
}

