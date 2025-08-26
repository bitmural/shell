import qs.services
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtQuick.VectorImage
import QtQuick.Effects

Pane {
  id: profileView

  background: Rectangle {
    color: Material.background
    radius: 8
  }

  GridLayout {
    anchors.fill: parent
    columns: 2
    rows: 2

    Image {
      id: pfp
      Layout.fillHeight: true
      Layout.preferredWidth: height
      Layout.rowSpan: 2
      source: 'luna_pfp_small.jpg'
      fillMode: Image.PreserveAspectFit
      layer.enabled: true
      layer.effect: MultiEffect {
          maskSource: mask
          maskEnabled: true
      }

      Rectangle {
        id: mask
        anchors.fill: pfp
        width: pfp.paintedWidth
        height: pfp.paintedHeight
        radius: pfp.paintedWidth * 0.5
        layer.enabled: true
        visible: false
      }

      Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "red" }
    }

    Pane {
      Layout.fillHeight: true
      Layout.preferredHeight: 1
      Layout.fillWidth: true
      padding: 0

      background: null

      RowLayout {
        anchors.fill: parent
        anchors.topMargin: 20
        spacing: 0
        VectorImage {
          Layout.preferredHeight: osPrettyNameLabel.contentHeight
          Layout.preferredWidth: osPrettyNameLabel.contentHeight
          Layout.rightMargin: 0.05 * Layout.preferredHeight
          Layout.leftMargin: 0.05 * Layout.preferredHeight
          // Align symbol vertical position with text label
          Layout.topMargin: 0.16 * osPrettyNameLabel.fontInfo.pixelSize

          source: "images/nixos.svg"
          fillMode: Image.PreserveAspectFit
          preferredRendererType: VectorImage.CurveRenderer
          Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
        }

        Label {
          id: osPrettyNameLabel
          Layout.fillHeight: true
          Layout.fillWidth: true
          text: qsTr("%1").arg([osRelease.osPrettyName])
          verticalAlignment: Text.AlignVCenter
          fontSizeMode: Text.Fit
          minimumPointSize: 8
          font.pointSize: 128
          Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
        }
      }

      FileView {
        id: osRelease

        property string osName
        property string osPrettyName
        property string osId
        property list<string> osIdLike
        property string logo

        path: "/etc/os-release"
        onLoaded: {
          const lines = text().split("\n");

          const fd = key => lines.find(l => l.startsWith(`${key}=`))?.split("=")[1].replace(/"/g, "") ?? "";

          osName = fd("NAME");
          osPrettyName = fd("PRETTY_NAME");
          osId = fd("ID");
          osIdLike = fd("ID_LIKE").split(" ");
          logo = fd("LOGO");
        }
      }
    }

    Pane {
      Layout.fillHeight: true
      Layout.preferredHeight: 1
      Layout.fillWidth: true
      padding: 0

      background: null

      RowLayout {
        anchors.fill: parent
        anchors.bottomMargin: 20
        spacing: 0
        VectorImage {
          Layout.preferredHeight: osPrettyNameLabel.contentHeight
          Layout.preferredWidth: osPrettyNameLabel.contentHeight
          Layout.rightMargin: 0.05 * Layout.preferredHeight
          Layout.leftMargin: 0.05 * Layout.preferredHeight
          // Align symbol vertical position with text label
          Layout.topMargin: 0.16 * osPrettyNameLabel.fontInfo.pixelSize

          source: "images/timer.svg"
          fillMode: VectorImage.PreserveAspectFit
          preferredRendererType: VectorImage.CurveRenderer
          layer.enabled: true
          layer.effect: MultiEffect { brightness: 1.0; colorization: 1.0; colorizationColor: Material.foreground }
          Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
        }

        Label {
          id: uptimeLabel
          Layout.fillHeight: true
          Layout.fillWidth: true
          text: qsTr("%1").arg(fileUptime.uptime)
          verticalAlignment: Text.AlignVCenter
          font.pointSize: osPrettyNameLabel.fontInfo.pointSize
          Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
        }
      }

      Timer {
        running: true
        repeat: true
        interval: 15000
        onTriggered: fileUptime.reload()
      }

      FileView {
        id: fileUptime
        property string uptime

        path: "/proc/uptime"
        onLoaded: {
            const up = parseInt(text().split(" ")[0] ?? 0);

            const days = Math.floor(up / 86400);
            const hours = Math.floor((up % 86400) / 3600);
            const minutes = Math.floor((up % 3600) / 60);

            let str = "";
            if (days > 0)
                str += `${days} day${days === 1 ? "" : "s"}`;
            if (hours > 0)
                str += `${str ? ", " : ""}${hours} hour${hours === 1 ? "" : "s"}`;
            if (minutes > 0 || !str)
                str += `${str ? ", " : ""}${minutes} minute${minutes === 1 ? "" : "s"}`;
            uptime = str;
        }
      }
    }
  }
}
