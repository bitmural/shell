import qs.services
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

GridLayout {
  property var pwnode
  property var comboBoxModel

  columns: panelWindow.layoutWide == false ? 2 : 1
  rows: columns == 1 ? 2 : 1

  RowLayout {
    Layout.fillWidth: true
    Layout.preferredWidth: 2
    Layout.minimumHeight: muteButton.height
    RoundButton {
      id: muteButton
      radius: 6
      icon.name: {
        if (pwnode?.audio?.muted)
          "volume_off"
        else if (pwnode?.audio?.volume == 0)
          "volume_mute"
        else if (pwnode?.audio?.volume < 0.5)
          "volume_down"
        else
          "volume_up"
        }
      icon.source: {
        if (pwnode?.audio?.muted)
          "../images/volume_off.svg"
        else if (pwnode?.audio?.volume == 0)
          "../images/volume_mute.svg"
        else if (pwnode?.audio?.volume < 0.5)
          "../images/volume_down.svg"
        else
          "../images/volume_up.svg"
        }

      icon.color: {
        if (pwnode?.audio?.muted)
          Material.accent
        else
          Material.foreground
      }
      onClicked: Audio.toggleMute(pwnode)

      ToolTip.visible: hovered
      ToolTip.delay: Application.styleHints.mousePressAndHoldInterval
      ToolTip.text: qsTr("Toggle Mute")
      Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
    }

    Slider {
      id: audioSlider
      wheelEnabled: true
      value: pwnode?.audio?.volume ?? 0
      onMoved: Audio.setVolume(pwnode, value)

      ToolTip {
          parent: audioSlider.handle
          visible: audioSlider.pressed
          font.pointSize: 12
          text: (audioSlider.value * 100).toFixed(0)
      }
      Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
    }

    Switch {
      checked: Audio.defaultSink?.id == pwnode?.id
      // text: qsTr("Default")
      display: AbstractButton.TextUnderIcon
      onClicked: {
        if (checked)
          Audio.setDefaultNode(pwnode);
      }
      Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
    }
  }

  ComboBox {
    id: audioSinksCombo
    model: comboBoxModel

    Layout.fillWidth: true
    Layout.preferredWidth: 3

    textRole: "description"
    font.pointSize: 14

    currentIndex: {
        for (var i = 0; i < comboBoxModel.length; i++)
          if (comboBoxModel[i]?.id === pwnode?.id)
            return i;
        return -1
    }

    onActivated: (index) => {
      pwnode = comboBoxModel[index]; }

    delegate: ItemDelegate {
      id: delegate

      required property var model
      required property int index

      width: audioSinksCombo.width
      contentItem: Label {
        verticalAlignment: Text.AlignVCenter
        text: delegate.model.id + ": " + delegate.model.description
        font.pointSize: 14
        elide: Text.ElideRight
      }
      highlighted: audioSinksCombo.highlightedIndex === index
    }

    Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
  }
}
