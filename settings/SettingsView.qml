import qs.services
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

//In here you will find Sound settings, Bluetooth settings, and Network settings

Pane {
  background: Rectangle {
    color: Material.background
    radius: 8
  }

  TabBar {
    id: bar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    currentIndex: 0

    TabButton {
      text: qsTr("Sound")
      icon.name: "speaker"
      icon.source: "../images/speaker.svg"
      icon.width: 32
      icon.height: 32
      font.pointSize: 20

    }
    TabButton {
      text: qsTr("Bluetooth")
      icon.name: "bluetooth"
      icon.source: "../images/settings_bluetooth"
      icon.width: 32
      icon.height: 32
      font.pointSize: 20
    }
    TabButton {
      text: qsTr("Network")
      icon.name: "wifi"
      icon.source: "../images/wifi"
      icon.width: 32
      icon.height: 32
      font.pointSize: 20
    }
  }

  StackLayout {
    id: stack
    anchors.top: bar.bottom
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    currentIndex: bar.currentIndex

    //
    // Sound
    //
    Pane {
      id: soundTab
      padding: 0
      topPadding: 12

      GridLayout {
        anchors.fill: parent
        columns: panelWindow.layoutWide ? 2 : 1

        GroupBox {
          id: soundSourcePage
          Layout.fillWidth: true
          Layout.preferredWidth: 1
          Layout.fillHeight: true

          title: qsTr("Audio Sources (Input)")
          label: Label {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            text: parent.title
            font.pointSize: 16
            background: Rectangle {
              opacity: soundSourcePage.hovered ? 0.7 : 0
              color: Material.accent
              radius: 100

              Behavior on opacity {
                OpacityAnimator {
                  duration: 200
                }
              }
            }
          }

          SoundNodeItem {
            id: sourceNodeItem
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            pwnode: Audio.defaultSource
            comboBoxModel: Audio.sources
          }

          PwNodeLinkTracker {
            id: sourceNodeTracker
            node: sourceNodeItem.pwnode
          }

          ListView {
            anchors.top: sourceNodeItem.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: 6
            snapMode: ListView.SnapToItem
            clip: true

            model: sourceNodeTracker.linkGroups

            delegate: Pane {
              padding: 2
              leftPadding: 8
              rightPadding: 8
              Label {
                text: modelData.target?.properties["media.name"] ? modelData.target?.name + ": " + modelData.source?.properties["media.name"]
                  : modelData.target?.name
                font.pointSize: 12
                Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
              }

              PwObjectTracker {
                objects: { modelData.target }
              }
            }
            Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
          }
        }

        GroupBox {
          id: soundSinkPage
          Layout.fillWidth: true
          Layout.preferredWidth: 1
          Layout.fillHeight: true
          hoverEnabled: true

          title: qsTr("Audio Sinks (Output)")
          label: Label {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            text: parent.title
            font.pointSize: 16
            background: Rectangle {
              opacity: soundSinkPage.hovered ? 0.7 : 0
              color: Material.accent
              radius: 100

              Behavior on opacity {
                OpacityAnimator {
                  duration: 200
                }
              }
            }
          }

          SoundNodeItem {
            id: sinkNodeItem
            anchors.left: parent.left
            anchors.right: parent.right
            // anchors.fill: parent

            pwnode: Audio.defaultSink
            comboBoxModel: Audio.sinks
          }

          PwNodeLinkTracker {
            id: sinkNodeTracker
            node: sinkNodeItem.pwnode
          }

          ListView {
            anchors.top: sinkNodeItem.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: 6
            snapMode: ListView.SnapToItem
            clip: true

            model: sinkNodeTracker.linkGroups

            delegate: Pane {
              padding: 2
              leftPadding: 8
              rightPadding: 8
              Label {
                text: modelData.source?.properties["media.name"] ? modelData.source?.name + ": " + modelData.source?.properties["media.name"]
                  : modelData.source?.name
                font.pointSize: 12
                Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
              }

              PwObjectTracker {
                objects: { modelData.source }
              }
            }
            Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
          }
        }
      }
    }

    //
    // Bluetooth
    //
    Pane {
      id: bluetoothTab
      padding: 0
      topPadding: 12

      GroupBox {
        id: bluetoothGroupBox
        anchors.fill: parent

        title: qsTr("Bluetooth Settings")
        label: RowLayout {
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          spacing: 0

          Switch {
            Layout.fillWidth: true
            Layout.preferredWidth: 3
            text: qsTr("Enabled")
            checked: btAdaptersCombo.selectedAdapter?.enabled ?? false
            font.pixelSize: 18
            onClicked: { if (btAdaptersCombo.selectedAdapter)
                           btAdaptersCombo.selectedAdapter.enabled = !btAdaptersCombo.selectedAdapter.enabled }
            Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
          }

          Switch {
            Layout.fillWidth: true
            Layout.preferredWidth: 3
            text: qsTr("Pairable")
            checked: btAdaptersCombo.selectedAdapter?.pairable ?? false
            font.pixelSize: 18
            onClicked: { if (btAdaptersCombo.selectedAdapter)
                            btAdaptersCombo.selectedAdapter.pairable = !btAdaptersCombo.selectedAdapter.pairable }
            Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
          }

          Switch {
            Layout.fillWidth: true
            Layout.preferredWidth: 4
            text: qsTr("Discovering")
            checked: btAdaptersCombo.selectedAdapter?.discovering ?? false
            font.pixelSize: 18
            onClicked: { if (btAdaptersCombo.selectedAdapter)
                          btAdaptersCombo.selectedAdapter.discovering = !btAdaptersCombo.selectedAdapter.discovering }
            Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
          }

          ComboBox {
            id: btAdaptersCombo
            Layout.fillWidth: true
            Layout.preferredWidth: 4

            model: Bluetooth.adapters.values
            property var selectedAdapter: Bluetooth.defaultAdapter

            textRole: "dbusPath"
            font.pointSize: 14
            currentIndex: model.indexOf(selectedAdapter)
            onActivated: (index) => { selectedAdapter = model[index]; }

            delegate: ItemDelegate {
              id: delegate

              required property var model
              required property int index

              width: btAdaptersCombo.width
              contentItem: Label {
                verticalAlignment: Text.AlignVCenter
                text: delegate.model.dbusPath
                font.pointSize: 14
                elide: Text.ElideRight
              }
              highlighted: btAdaptersCombo.highlightedIndex === index
            }
            Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
          }
        } // Bluetooth Adapter Selection (Label area)

        ListView {
          id: btItemsListView
          anchors.fill: parent
          snapMode: ListView.SnapToItem
          clip: true
          model: ScriptModel {
            values: [...Bluetooth.devices.values].sort((a, b) => {
              const nameA = a.name.toUpperCase();
              const nameB = b.name.toUpperCase();
              if (a.paired && b.paired) {
                if (nameA < nameB)
                  return -1;
                if (nameA > nameB)
                  return 1;
                else
                  return 0;
              }
              if (a.paired && !b.paired)
                return -1;
              if (!a.paired && b.paired)
                return 1;
              else
                return 0
            })
          }

          delegate: BluetoothItem {
            anchors.left: parent.left ?? undefined
            anchors.right: parent.right ?? undefined
            // Layout.fillWidth: true
            // Layout.preferredWidth: bluetoothGroupBox.width
            btDevice: modelData
          }
          Rectangle { anchors.fill: btItemsListView; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
        } // Bluetooth Adapter devices paired & discovered

        // ScrollIndicator.vertical: ScrollIndicator { }

      } // Scrollview of bluetooth devices
    }

    //
    // Network
    //
    Pane {
      id: networkTab
      Rectangle { width: 100; height: 100; radius: 20.0
                  color: "blue"; anchors.fill: parent }
    }
  }
}
