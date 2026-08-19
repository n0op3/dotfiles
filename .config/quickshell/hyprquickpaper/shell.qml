// credit to https://github.com/iamsurjog for the original script

import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell.Wayland

PanelWindow {
    id: main
    implicitHeight: 500
    implicitWidth: Screen.width
    color: "transparent"

    property int animDuration: 100
    property int animEasing: Easing.OutCubic

    aboveWindows: true
    exclusionMode: "Ignore"
    exclusiveZone: 1

    WlrLayershell.namespace: "wallpaper-picker"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    Component.onCompleted: {
        Quickshell.execDetached(["bash", Quickshell.shellPath("cache.sh"), Quickshell.shellDir])
        console.log(Quickshell.shellDir)
    }

    FileView {
        path: Quickshell.shellPath("config.json")
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: configs
            property string wallpaper_path
            property string cache_path
            property int number_of_pictures
        }
    }

    FolderListModel {
        id: folderModel
        folder: "file://" + configs.wallpaper_path
        showDirs: false
        nameFilters: ["*.png","*.jpg",".jpeg"]
        sortField: FolderListModel.Time
        // sortReversed: true

        onStatusChanged: {
            if (status === FolderListModel.Ready) {
                list.selectedIndex = configs.number_of_pictures / 2
                list.centerTile(list.selectedIndex)
            }
        }
    }

    ListView {
        id: list
        anchors.fill: parent
        focus: true

        model: folderModel
        orientation: ListView.Horizontal
        spacing: 4
        clip: true
        // reuseItems: true
        cacheBuffer: width * 2

        property int selectedIndex: 0
        property real tileWidth: width / configs.number_of_pictures + spacing * 2

        function clampIndex(i) {
            return (count + i) % count
        }

        function activateCurrent() {
            const path = folderModel.get(selectedIndex, "filePath")
            Quickshell.execDetached(["bash", Quickshell.shellPath("commands.sh"), path])
            Qt.quit()
        }

        function clampX(x) {
            return Math.max(0, Math.min(x, contentWidth - width))
        }

        function centerTile(i) {
            const step = tileWidth + spacing
            const itemStart = i * step
            const itemCenter = itemStart + tileWidth / 2
            const centerX = itemCenter - width / 2   // width, not Screen.width — and now depends on i

            contentX = Math.max(0, Math.min(centerX, contentWidth - width))  // clamp yourself
            console.log(`${i}: ${itemStart} ${centerX} ${contentX}`)
        }

        Behavior on contentX       { NumberAnimation { duration: animDuration; easing.type: animEasing } }

        delegate: Item {
            property bool active: index === list.selectedIndex
            width: list.tileWidth
            height: 500 - Math.abs(index - list.selectedIndex) * 50
            anchors.verticalCenter: parent.verticalCenter
            property int dist: Math.abs(index - list.selectedIndex)
            opacity: {
                return Math.max(0.0, 1.0 - dist * dist * 0.2)
            }

            Behavior on opacity { NumberAnimation { duration: animDuration / 2 } }
            Behavior on width  { NumberAnimation { duration: animDuration; easing.type: animEasing } }
            Behavior on height { NumberAnimation { duration: animDuration; easing.type: animEasing } }
            Behavior on y       { NumberAnimation { duration: animDuration; easing.type: animEasing } }

            Item {
                id: visual
                anchors.centerIn: parent
                width: parent.width * Math.max(0.5, 1.0 - dist * 0.15)
                height: parent.height

                Text {
                    id: alt
                    text: "Loading"
                    anchors.centerIn: parent
                    color: "white"
                    font.italic: true
                    opacity: 0.5
                }

                Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
                Image {
                    id: img
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop

                    asynchronous: true
                    cache: true
                    smooth: true

                    source: "file://" + configs.cache_path + fileName

                    sourceSize.width: 500
                    sourceSize.height: 500

                    Timer {
                        id: retryTimer
                        interval: 1000
                        repeat: false
                        onTriggered: {
                            let s = img.source
                            img.source = ""
                            img.source = s
                        }
                    }

                    onStatusChanged: {
                        if (status === Image.Error) {
                            alt.text = "Caching"
                            retryTimer.start()
                        } else if (status == Image.Ready) {
                            // alt.text = ""
                        }
                    }
                }
            }
        }

        Keys.onPressed: function(event) {
            const step = 1
            const big = configs.number_of_pictures

            if (event.key === Qt.Key_J || event.key === Qt.Key_L) {
                selectedIndex = clampIndex(selectedIndex + step)
                centerTile(selectedIndex)

            } else if (event.key === Qt.Key_K || event.key === Qt.Key_H) {
                selectedIndex = clampIndex(selectedIndex - step)
                centerTile(selectedIndex)

            } else if (event.key === Qt.Key_D) {
                selectedIndex = clampIndex(selectedIndex + big)
                centerTile(selectedIndex)

            } else if (event.key === Qt.Key_U) {
                selectedIndex = clampIndex(selectedIndex - big)
                centerTile(selectedIndex)

            } else if (event.key === Qt.Key_Space || event.key === Qt.Key_Return) {
                activateCurrent()

            } else if (event.key === Qt.Key_Escape) {
                Qt.quit()

            } else return

            event.accepted = true
        }
    }
}
