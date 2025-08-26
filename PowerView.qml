import qs.services
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Pane {
  background: Rectangle {
    color: Material.background
    radius: 8
  }

  RowLayout {
    anchors.fill: parent
      RoundButton {
        Layout.fillHeight: true
        Layout.preferredWidth: height
        Layout.alignment: Qt.AlignHCenter

        ToolTip.visible: hovered
        ToolTip.delay: Application.styleHints.mousePressAndHoldInterval
        ToolTip.text: qsTr("Suspend")

        icon.name: "bedtime"
        icon.source: "images/bedtime.svg"
        icon.width: width * 0.9
        icon.height: height * 0.9
        radius: 6
        onClicked: suspendDialog.visible = true

        Dialog {
          id: suspendDialog
          anchors.centerIn: Overlay.overlay
          modal: true
          visible: false
          title: "Confirm Suspend"
          standardButtons: Dialog.Ok | Dialog.Cancel

          Material.theme: Material.Dark
          Material.accent: Material.Purple

          onAccepted: {
            panelWindow.visible = !panelWindow.visible
            Quickshell.execDetached(["systemctl", "suspend"])
          }
        }
        Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
      }

    //Restart
    RoundButton {
      Layout.fillHeight: true
      Layout.preferredWidth: height
      Layout.alignment: Qt.AlignHCenter

      ToolTip.visible: hovered
      ToolTip.delay: Application.styleHints.mousePressAndHoldInterval
      ToolTip.text: qsTr("Restart")

      icon.name: "restart_alt"
      icon.source: "images/restart_alt.svg"
      icon.width: width * 0.9
      icon.height: height * 0.9
      radius: 6
      onClicked: restartDialog.visible = true

      Dialog {
        id: restartDialog
        anchors.centerIn: Overlay.overlay
        modal: true
        visible: false
        title: "Confirm Restart"
        standardButtons: Dialog.Ok | Dialog.Cancel

        Material.theme: Material.Dark
        Material.accent: Material.Purple

        onAccepted: Quickshell.execDetached(["systemctl", "reboot"])
      }
      Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
    }

    //Shutdown
    RoundButton {
      id: shutdownButton
      Layout.fillHeight: true
      Layout.preferredWidth: height
      Layout.alignment: Qt.AlignHCenter

      ToolTip.visible: hovered
      ToolTip.delay: Application.styleHints.mousePressAndHoldInterval
      ToolTip.text: qsTr("Poweroff")

      icon.name: "mode_off_on"
      icon.source: "images/mode_off_on.svg"
      icon.width: width * 0.9
      icon.height: height * 0.9
      radius: 6
      onClicked: poweroffDialog.visible = true

      Dialog {
        id: poweroffDialog
        anchors.centerIn: Overlay.overlay
        modal: true
        visible: false
        title: "Confirm Poweroff"
        standardButtons: Dialog.Ok | Dialog.Cancel

        Material.theme: Material.Dark
        Material.accent: Material.Purple

        onAccepted: Quickshell.execDetached(["systemctl", "poweroff"])
      }
      Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
    }
  }
}
