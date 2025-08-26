import qs.settings
import qs.services
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.Effects

ShellRoot {
  id: root

  PersistentProperties {
    id: persist
    reloadableId: "persistedStates"

    property bool debugMode
  }

  PanelWindow {
    id: panelWindow
    visible: true
    readonly property bool layoutWide: width > height
    readonly property real screenMarginVFactor: layoutWide ? 0.15 : 0.06
    readonly property real screenMarginHFactor: layoutWide ? 0.12 : 0.06

    anchors {
      top: true
      bottom: true
      left: true
      right: true
    }

    color: "transparent"

    Image {
      id: backgroundImage

      visible: Config.backgroundEnabled

      property real elapsedTime
      anchors.fill: parent
      source: Config.backgroundImageSource
      fillMode: Image.PreserveAspectFit
      opacity: Config.backgroundImageOpacity
      layer.enabled: Config.backgroundShaderEnabled
      layer.effect: ShaderEffect {
        readonly property variant iSource: backgroundImage
        readonly property real iTime: backgroundImage.elapsedTime
        readonly property vector3d iResolution: Qt.vector3d(width, height, 1.0)
        vertexShader: "shaders/Raindrop 1.vert.qsb"
        fragmentShader: "shaders/Raindrop 1.frag.qsb"
        anchors.fill: parent
      }
      NumberAnimation on elapsedTime {
        to: 30000
        duration: 30000000
        paused: !panelWindow.visible
      }
    }

    MouseArea {
      anchors.fill: parent
      //Negative margin for layout clipping wiggle room at the very edge of screens
      anchors.margins: -3
      onClicked: {
        panelWindow.visible = !panelWindow.visible
      }
    }

    Item {
    // PanelWindow {
     	id: contentArea

      opacity: Config.contentOpacity

      Behavior on opacity {
        OpacityAnimator { duration: 200 }
      }

      Material.theme: Material.Dark
      Material.accent: Material.Purple

      anchors.fill: parent
      // width: 1920 height: 1080 || width: 1080 height: 1920

      anchors.topMargin: panelWindow.height * panelWindow.screenMarginVFactor
      anchors.bottomMargin: anchors.topMargin
      anchors.leftMargin: panelWindow.width * panelWindow.screenMarginHFactor
      anchors.rightMargin: anchors.leftMargin

      // margins {
      //   top: panelWindow.height * panelWindow.screenMarginVFactor
      //   bottom: anchors.topMargin
      //   left: panelWindow.width * panelWindow.screenMarginHFactor
      //   right: anchors.leftMargin
      // }

      readonly property real rowRatioA: panelWindow.layoutWide ? 3 : 3
      readonly property real rowRatioB: panelWindow.layoutWide ? 9 : 12
      readonly property real rowRatioC: panelWindow.layoutWide ? 2 : 1

      //Mask click away/minimize mouse area for content
      MouseArea {
        anchors.fill: parent
      }

      ColumnLayout {
        anchors.fill: parent

        //
        // TOP SECTION
        //
        GridLayout {
          id: top_section

          Layout.preferredWidth: contentArea.width;

          Layout.fillHeight: true
          Layout.preferredHeight: contentArea.rowRatioA

          rows: panelWindow.layoutWide ? 1 : 2
          columns: panelWindow.layoutWide ? 3 : 2

          TimeView {
            Layout.columnSpan: panelWindow.layoutWide ? 1 : 2

            Layout.fillWidth: true
            Layout.preferredWidth: 1

            Layout.fillHeight: true
            Layout.preferredHeight: contentArea.rowRatioA

            opacity: 0.9
          }

         	ProfileView {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredWidth: 1

            Layout.fillHeight: true
            Layout.preferredHeight: contentArea.rowRatioA

            opacity: 0.9
          }

         	PowerView {
            Layout.alignment: Qt.AlignRight
            Layout.fillWidth: true
            Layout.preferredWidth: 1

            Layout.fillHeight: true
            Layout.preferredHeight: contentArea.rowRatioA

            opacity: 0.9
          }
        }

        //
        // MIDDLE SECTION
        //
        GridLayout {
          columns: panelWindow.layoutWide ? 2 : 1

          Layout.preferredWidth: contentArea.width

          Layout.fillHeight: true
          Layout.preferredHeight: contentArea.rowRatioB

          uniformCellWidths: true

          SettingsView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: contentArea.rowRatioB * 0.65
          }

          SystemTrayView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: contentArea.rowRatioB * 0.35
          }
        }

        //
        // BOTTOM SECTION
        //
        GridLayout {
          Layout.fillWidth: true
          Layout.fillHeight: true
          Layout.preferredHeight: contentArea.rowRatioC

         	Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: contentArea.rowRatioC
            // Layout.rowSpan: 2
            radius: 6
            color: "plum"
            opacity: 0.7

            MouseArea {
              anchors.fill: parent
              onClicked: { parent.color = 'red' }
            }
          }

          Pane {
            Layout.fillHeight: true
            spacing: 0
            Button {
              anchors.centerIn: parent
              icon.source: configDrawer.visible ? "images/right_panel_close.svg" : "images/right_panel_open.svg"
              onClicked: configDrawer.visible = !configDrawer.visible
            }

            background: Rectangle {
              color: Material.background
              radius: 8
            }
          }
        }
      }
    }

    Drawer {
      id: configDrawer
      parent: panelWindow
      width: panelWindow.layoutWide ? contentArea.width * 0.4 : contentArea.width * 0.65
      height: panelWindow.height

      Material.theme: Material.Dark
      Material.accent: Material.Purple

      edge: Qt.RightEdge
      modal: false

      visible: false

      Pane {
        height: parent.height
        width: parent.width

        GridLayout {
          anchors.fill: parent

          columns: 3
          rows: 3

          ConfigView {
            // Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            Layout.columnSpan: 3
            Layout.rowSpan: 2
          }

          Button {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
            width: 40
            height: 40
            icon.source: configDrawer.visible ? "images/right_panel_close.svg" : "images/right_panel_open.svg"
            onClicked: configDrawer.visible = !configDrawer.visible
          }

          CheckBox {
            Layout.alignment: Qt.AlignRight | Qt.AlignBottom
            checked: Config.debugModeEnabled
            onClicked: Config.debugModeEnabled = checked
          }
        }
      }

      background: Rectangle {
        color: Material.background
        radius: 16
      }
    }

    GlobalShortcut {
      name: "desktop"
      description: "Show/Hide Desktop Panel"
      onPressed: {
        panelWindow.visible = !panelWindow.visible
      }
    }
  }
}
