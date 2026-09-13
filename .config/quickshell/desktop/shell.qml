import Quickshell
import Quickshell.Wayland
import QtQuick
import "."

PanelWindow {
    id: root
      color: "transparent"
      BackgroundEffect.blurRegion: Region { item: root.contentItem }

      WlrLayershell.layer: WlrLayer.Bottom
      implicitWidth: 350
      implicitHeight: 160

      anchors {
          left: true
          top: true
      }

      margins {
          left: 32
          top: 32
      }

      Rectangle {
          color: Qt.alpha(Pywal.surface, 0.8)

          border {
              color: Pywal.tertiary
              width: 2
          }

          anchors.fill: parent
          radius: 18

          SystemClock {
              id: clock
              precision: SystemClock.Minutes
          }

          Text {
              color: Pywal.foreground

              text: Qt.formatDateTime(clock.date, "hh:mm")
              
              anchors {
                  left: parent.left
                  top: parent.top
                  leftMargin: 12
                  topMargin: 12
              }

              font {
                  family: "FiraCode Bold"
                  pixelSize: 85
                  weight: 600
              }

              Text {
                  text: Qt.formatDateTime(clock.date, "dd MMM")
                  color: Pywal.onSurfaceMuted

                  anchors {
                      left: parent.left
                      top: parent.bottom
                      leftMargin: 12
                  }

                  font {
                      pixelSize: 24
                  }
              }
          }
      }
}
