import qs.services
import qs.controls
import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.VectorImage
import QtQuick.Effects

RowLayout {
  id: bluetoothItem
  property BluetoothDevice btDevice

  Rectangle {
    Layout.fillHeight: true
    Layout.topMargin: 5
    Layout.bottomMargin: 5
    Layout.preferredWidth: 2
    width: rowHoverer.hovered ? 2 : 1
    color: Material.foreground
    opacity:  rowHoverer.hovered ? 1.0 : 0.2

    Behavior on opacity {
      OpacityAnimator {
        duration: 100
        easing.type: Easing.OutCubic
      }
    }
  }

  BusyIndicator {
    // Layout.fillWidth: true
    running: !btDevice?.paired
    Layout.preferredWidth: running ? connectCheckBox.width : 0
    Layout.preferredHeight: running ? connectCheckBox.height : 0
    // Layout.rightMargin: 40
    Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
  }

  Label {
    // Layout.fillHeight: true
    Layout.preferredHeight: connectCheckBox.height - connectCheckBox.height * 0.2
    Layout.fillWidth: true
    // Layout.preferredWidth: 1
    text: btDevice?.name ?? btDevice?.deviceName ?? ""
    fontSizeMode: Text.VerticalFit
    minimumPointSize: 8
    font.pointSize: 128
    elide: Text.ElideRight

    HoverHandler {
      id: labelHoverer
      acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    ToolTip {
      visible: labelHoverer.hovered
      delay: Application.styleHints.mousePressAndHoldInterval
      text: btDevice?.address ?? ""
    }

    Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
  }

  // Pairing/bonding/trusting is feeling a little wonky
  // RoundButton {
  //   radius: 6
  //   text: btDevice?.paired ? qsTr("Forget") : qsTr("Pair")
  //   onClicked: btDevice?.paired ? btDevice?.forget() : btDevice?.pair()
  //   Layout.preferredHeight: connectCheckBox.height
  // }

  //
  // btDevice.batteryEnabled
  //

  VectorImage {
    source: "../images/block.svg"
    fillMode: VectorImage.PreserveAspectFit
    width: connectCheckBox.width
    height: connectCheckBox.height
    preferredRendererType: VectorImage.CurveRenderer
    layer.enabled: true
    layer.effect: MultiEffect {
      brightness: btDevice?.blocked ? 1.0 : 0.4
      colorization: 1.0
      colorizationColor: btDevice?.blocked ?  Material.accent : Material.foreground
    }

    HoverHandler {
        id: blockedHoverer
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    ToolTip {
      visible: blockedHoverer.hovered
      delay: Application.styleHints.mousePressAndHoldInterval
      text: {
        if (btDevice?.blocked)
          qsTr("Blocked")
        else
          qsTr("Not Blocked")
      }
    }

    Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
  }

  VectorImage {
    source: "../images/verified_user.svg"
    fillMode: VectorImage.PreserveAspectFit
    width: connectCheckBox.width
    height: connectCheckBox.height
    preferredRendererType: VectorImage.CurveRenderer
    layer.enabled: true
    layer.effect: MultiEffect {
      brightness: btDevice?.trusted ? 1.0 : 0.4
      colorization: 1.0
      colorizationColor: btDevice?.trusted ?  Material.accent : Material.foreground
    }

    HoverHandler {
        id: trustedHoverer
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        // cursorShape: Qt.PointingHandCursor
    }

    ToolTip {
      visible: trustedHoverer.hovered
      delay: Application.styleHints.mousePressAndHoldInterval
      text: {
        if (btDevice?.trusted)
          qsTr("Trusted")
        else
          qsTr("Not Trusted")
      }
    }

    Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
  }

  VectorImage {
    source: "../images/lock.svg"
    fillMode: VectorImage.PreserveAspectFit
    width: connectCheckBox.width
    height: connectCheckBox.height
    preferredRendererType: VectorImage.CurveRenderer
    layer.enabled: true
    layer.effect: MultiEffect {
      brightness: btDevice?.bonded ? 1.0 : 0.4
      colorization: 1.0
      colorizationColor: btDevice?.bonded ?  Material.accent : Material.foreground
    }

    HoverHandler {
        id: bondedHoverer
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    ToolTip {
      visible: bondedHoverer.hovered
      delay: Application.styleHints.mousePressAndHoldInterval
      text: {
        if (btDevice?.bonded)
          qsTr("Bonded")
        else
          qsTr("Not Bonded")
      }
    }

    Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
  }

  // Connect/Disconnect button
  IconCheckBox {
    id: connectCheckBox
    checked: btDevice?.connected || btDevice?.state == 3
    iconSource: {
      if (btDevice?.connected || btDevice?.state == 2)
        "../images/bluetooth_connected.svg"
      else
        "../images/bluetooth.svg"
    }

    onClicked: {
      if (btDevice?.state == 0)
        btDevice?.connect();
      else if(btDevice?.state == 1)
        btDevice?.disconnect()
    }

    ToolTip.visible: hovered
    ToolTip.delay: Application.styleHints.mousePressAndHoldInterval
    ToolTip.text: {
      switch(btDevice?.state) {
        case 0:
          return qsTr("Disconnected"); break;
        case 1:
          return qsTr("Connected"); break;
        case 2:
          return qsTr("Disconnecting"); break;
        case 3:
          return qsTr("Connecting"); break;
      }
      return "";
    }

    Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
  }

  Rectangle {
    Layout.fillHeight: true
    Layout.topMargin: 5
    Layout.bottomMargin: 5
    Layout.preferredWidth: 2
    width: rowHoverer.hovered ? 2 : 1
    color: Material.foreground
    opacity:  rowHoverer.hovered ? 1.0 : 0.2

    Behavior on opacity {
      OpacityAnimator {
        duration: 100
        easing.type: Easing.OutCubic
      }
    }
  }

  HoverHandler {
    id: rowHoverer
    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
  }
}
