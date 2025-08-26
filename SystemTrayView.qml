import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Pane {
  background: Rectangle {
  color: Material.background
  radius: 8
}
  ScrollView {
    Grid {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter

      spacing: 5

      Repeater {
        model: SystemTray.items

        delegate: Item {
          property SystemTrayItem trayItem: modelData

          width: 100
          height: 100

          ToolTip.visible: trayItemArea.containsMouse
          ToolTip.delay: Application.styleHints.mousePressAndHoldInterval
          ToolTip.text: qsTr(modelData.title)

          Rectangle {
            anchors.fill: parent
            id: item_background
            radius: 6
            opacity: trayItemArea.containsMouse ? 0.7 : 0
            color: Material.accent

            Behavior on opacity {
              enabled: trayItemArea.containsMouse !== undefined
              OpacityAnimator {
                duration: 200
              }
            }
          }

          Image {
            anchors.centerIn: parent
            width: 80
            height: 80
            source: {
                let icon = trayItem.icon;
                if (icon.includes("?path=")) {
                    const [name, path] = icon.split("?path=");
                    icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
                }
                return icon;
            }
            asynchronous: true
            smooth: true
            fillMode: Image.PreserveAspectFit
          }

          MouseArea {
            id: trayItemArea

            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: event => {
              if (event.button === Qt.LeftButton) {
                modelData.activate();
                root.visible = !root.visible
                focus_event.parse() }
              else if (modelData.hasMenu) {
                menuAnchor.open(); }
            }
          }
        }
      }
    }
  }
}
