pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // Runtime properties
  property real contentOpacity: 1.0

  // Saved properties
  property alias debugModeEnabled: adapter.debugModeEnabled
  property alias backgroundEnabled: adapter.backgroundEnabled
  property alias backgroundShaderEnabled: adapter.backgroundShaderEnabled
  property alias backgroundShaderSource: adapter.backgroundShaderSource
  property alias backgroundImageEnabled: adapter.backgroundImageEnabled
  property alias backgroundImageOpacity: adapter.backgroundImageOpacity
  property alias backgroundImageSource: adapter.backgroundImageSource
  property alias backgroundColorEnabled: adapter.backgroundColorEnabled
  // property color backgroundColor

  FileView {
    path: Quickshell.shellDir + "/config.json"
    watchChanges: true
    onFileChanged: reload()
    onAdapterUpdated: writeAdapter();

    JsonAdapter {
      id: adapter
      property bool debugModeEnabled
      property bool backgroundEnabled
      property bool backgroundImageEnabled
      property real backgroundImageOpacity
      property string backgroundImageSource
      property bool backgroundColorEnabled
      property bool backgroundShaderEnabled
      property string backgroundShaderSource
    }
  }
}
