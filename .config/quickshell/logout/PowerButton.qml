import QtQuick

Item {
    id: root
    implicitWidth: 200
    implicitHeight: 200

    property string label: "button"
    property alias color: bg.color

    signal clicked()

    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#333333"
        radius: width


        Text {
            anchors.centerIn: parent
            text: root.label
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.clicked()
        }
    }
}
