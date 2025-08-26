import qs.services
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls.Material
import QtQuick.Layouts

Pane {
  background: Rectangle {
    color: Material.background
    radius: 8
  }

  RowLayout {
    anchors.fill: parent

    Label {
      id: time_text
      Layout.rowSpan: 2
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredWidth: 1
      Layout.topMargin: 0.1 * day_text.fontInfo.pixelSize
      horizontalAlignment: Text.AlignRight
      fontSizeMode: Text.Fit
      minimumPointSize: 24
      font.pointSize: 128
      text: Qt.formatDateTime(clock.date, "hh:mm")
      Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
    }

    Label {
      id: day_text
      Layout.fillHeight: true
      Layout.fillWidth: true
      Layout.preferredWidth: 1
      fontSizeMode: Text.Fit
      minimumPointSize: 12
      font.pointSize: 128
      text: Qt.formatDateTime(clock.date, "dddd,") + "\n" + Qt.formatDateTime(clock.date, "MMMM dd")
      Rectangle { anchors.fill: parent; opacity: Config.debugModeEnabled ? .25 : 0; color: "yellow" }
    }

    SystemClock {
      id: clock
      precision: SystemClock.Minutes
    }
  }
}
