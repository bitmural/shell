import qs.services
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Pane {
  ColumnLayout{
    anchors.left: parent.left
    anchors.right: parent.right

    GroupBox {
      id: backgroundGroupBox
      title: qsTr("Background")
      label: Label {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter
        text: parent.title
        font.pointSize: 14
        background: Rectangle {
          opacity: {
            if (backgroundGroupBox.hovered) {
              Config.contentOpacity = 0.0;
              return 0.7;
            }
            else {
              Config.contentOpacity = 1.0;
              return 0.0;
            }
          }
          color: Material.accent
          radius: 100

          Behavior on opacity {
            OpacityAnimator {
              duration: 200
            }
          }
        }
      }

      GridLayout{
        anchors.left: parent.left
        anchors.right: parent.right

        columns: 2

        CheckBox {
          Layout.columnSpan: 2
          checked: Config.backgroundEnabled
          onClicked: Config.backgroundEnabled = checked
          text: qsTr("Enable Background")
        }
        CheckBox {
          checked: Config.backgroundShaderEnabled
          onClicked: Config.backgroundShaderEnabled = checked
          text: qsTr("Enable Background Shader")
          Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
        }

        // TextField{
        //   Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
        // }
        // CheckBox {
        //   checked: Config.backgroundImageEnabled
        //   onClicked: Config.backgroundImageEnabled = checked
        //   text: qsTr("Background Image")
        // }

        // TextField{
        //   Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
        // }
        Slider {
          Layout.columnSpan: 2
          value: Config.backgroundImageOpacity
          onMoved: Config.backgroundImageOpacity = value
        }

        // CheckBox {
        //   checked: Config.backgroundColorEnabled
        //   onClicked: Config.backgroundColorEnabled = checked
        //   text: qsTr("Background Color")
        // }
        // TextField{
        //   Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
        // }
      }
    }
  }
}
