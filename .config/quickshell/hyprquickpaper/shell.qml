// credit to https://github.com/iamsurjog for the original script

import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: main
    implicitHeight: Screen.height
    implicitWidth: Screen.width
    color: "transparent"

    property int animDuration: 300
    property int animEasing: Easing.OutCubic
    property var folderNames: ["All"]
    property int folderIndex: 0

    function applyFilter() {
        fileList.clear()
        const name = folderNames[folderIndex]
        for (let i = 0; i < allFiles.count; i++) {
            const f = allFiles.get(i)
            if (folderIndex === 0 || f.folder === name)
            fileList.append({ filePath: f.filePath, fileName: f.fileName, folder: f.folder })
        }
        if (fileList.count === 0) return
        list.selectedIndex = Math.min(Math.floor(configs.number_of_pictures / 2), fileList.count - 1)
        list.previousIndex = list.selectedIndex
        list.centerTile(list.selectedIndex)
    }

    function cycleFolder(dir) {
        folderIndex = (folderIndex + dir + folderNames.length) % folderNames.length
        switchAnim.restart()
    }

    ListModel { id: allFiles }

    aboveWindows: true
    exclusionMode: "Ignore"
    exclusiveZone: 1

    WlrLayershell.namespace: "wallpaper-picker"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    Component.onCompleted: {
        Quickshell.execDetached(["bash", Quickshell.shellPath("cache.sh"), Quickshell.shellDir])
    }

    SequentialAnimation {
        id: switchAnim
        NumberAnimation { target: list; property: "opacity"; to: 0; duration: 150 }
        ScriptAction { script: main.applyFilter() }
        NumberAnimation { target: list; property: "opacity"; to: 1; duration: 250 }
    }

    FileView {
        path: Quickshell.shellPath("config.json")
        watchChanges: true
        onFileChanged: reload()
        onLoaded: finder.running = true

        JsonAdapter {
            id: configs
            property string wallpaper_path
            property string cache_path
            property int number_of_pictures
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 200
        color: "white"
        font.pixelSize: 20
        text: main.folderNames[main.folderIndex] + " (" + fileList.count + ")"
    }

    ListModel { id: fileList }

    Process {
        id: finder
        command: ["sh", "-c",
            "find \"$1\" -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \\) -printf '%T@ %p\\n' | sort -nr | cut -d' ' -f2-",
            "sh", configs.wallpaper_path]

        stderr: StdioCollector {
            onStreamFinished: console.log("find stderr:", JSON.stringify(text))
        }

        stdout: StdioCollector {
            onStreamFinished: {
                const base = configs.wallpaper_path.replace(/\/+$/, "") + "/"
                const seen = new Set()
                allFiles.clear()
                for (const p of text.split("\n")) {
                    if (!p) continue
                    const rel = p.startsWith(base) ? p.substring(base.length) : p
                    const slash = rel.lastIndexOf("/")
                    const folder = slash === -1 ? "." : rel.substring(0, slash)
                    seen.add(folder)
                    allFiles.append({
                        filePath: p,
                        fileName: p.substring(p.lastIndexOf("/") + 1),
                        folder: folder
                    })
                }
                folderNames = ["All", ...Array.from(seen).sort()]
                folderIndex = 0
                applyFilter()
            }
        }
    }

    ListView {
        id: list
        anchors.fill: parent
        focus: true

        model: fileList
        orientation: ListView.Horizontal
        spacing: -300
        clip: true
        // reuseItems: true
        cacheBuffer: width * 2

        property int selectedIndex: 0
        property int previousIndex: 0
        property real tileWidth: width / configs.number_of_pictures * 1.5

        function clampIndex(i) {
            return (count + i) % count
        }

        function activateCurrent() {
            const path = fileList.get(selectedIndex).filePath
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
            const centerX = itemCenter - width / 2

            contentX = Math.max(0, Math.min(centerX, contentWidth - width))
        }

        function selectIndex(newIndex) {
            previousIndex = selectedIndex
            selectedIndex = newIndex
            centerTile(newIndex)
            transitionTimer.restart()
        }

        Timer {
            id: transitionTimer
            interval: animDuration
            onTriggered: list.previousIndex = list.selectedIndex
        }

        Behavior on contentX {
            enabled: !switchAnim.running
            NumberAnimation { duration: animDuration; easing.type: animEasing }
        }

        delegate: Item {
            id: tileRoot
            property bool active: index === list.selectedIndex
            width: list.tileWidth
            height: 400 - Math.abs(Math.pow(Math.abs(index - list.selectedIndex), 2)) * 50
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -100 * Math.abs(index - list.selectedIndex)
            property int dist: Math.abs(index - list.selectedIndex)

            opacity: {
                return Math.max(0.0, 1.0 - dist * dist * 0.2)
            }

            z: {
                if (index === list.selectedIndex) return 2
                if (index === list.previousIndex) return 1
                return opacity
            }

            Behavior on opacity { NumberAnimation { duration: animDuration; easing.type: animEasing } }
            Behavior on width   { NumberAnimation { duration: animDuration; easing.type: animEasing } }
            Behavior on height  { NumberAnimation { duration: animDuration; easing.type: animEasing } }
            Behavior on anchors.verticalCenterOffset       { NumberAnimation { duration: animDuration; easing.type: animEasing } }

            ClippingRectangle {
                id: visual
                anchors.centerIn: parent
                width: parent.width * Math.max(0.5, 1.0 - dist * 0.15)
                height: parent.height
                radius: 24
                color: "transparent"

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
                    layer.enabled: true

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
                            alt.text = ""
                        }
                    }
                }
            }
        }

        Keys.onPressed: function(event) {
            const step = 1
            const big = configs.number_of_pictures

            if (event.key === Qt.Key_J || event.key === Qt.Key_L) {
                selectIndex(clampIndex(selectedIndex + step))

            } else if (event.key === Qt.Key_K || event.key === Qt.Key_H) {
                selectIndex(clampIndex(selectedIndex - step))

            } else if (event.key === Qt.Key_D) {
                selectIndex(clampIndex(selectedIndex + big))

            } else if (event.key === Qt.Key_U) {
                selectIndex(clampIndex(selectedIndex - big))

            } else if (event.key === Qt.Key_Space || event.key === Qt.Key_Return) {
                activateCurrent()

            } else if (event.key === Qt.Key_Escape) {
                Qt.quit()
            } else if (event.key === Qt.Key_Tab) {
                main.cycleFolder(1)

            } else if (event.key === Qt.Key_Backtab) {
                main.cycleFolder(-1)
            } else return

            event.accepted = true
        }
    }
}
