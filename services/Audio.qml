pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  readonly property var nodes: Pipewire.nodes.values.reduce((acc, node) => {
      if (node.isStream)
        acc.streams.push(node);
      else {
          if (node.isSink)
              acc.sinks.push(node);
          else if (node.audio)
              acc.sources.push(node);
      }
      return acc;
  }, {
      streams: [],
      sources: [],
      sinks: []
  })

  readonly property list<PwNode> sinks: nodes.sinks
  readonly property list<PwNode> sources: nodes.sources
  readonly property list<PwNode> streams: nodes.streams

  readonly property PwNode defaultSink: Pipewire.defaultAudioSink
  readonly property PwNode defaultSource: Pipewire.defaultAudioSource

  readonly property bool muted: defaultSink?.audio?.muted ?? false
  readonly property real volume: defaultSink?.audio?.volume ?? 0

  function setVolume(node: PwNode, volume: real): void {
    if (node?.ready && node?.audio) {
      node.audio.muted = false;
      node.audio.volume = Math.max(0, Math.min(1, volume));
    }
  }

  function toggleMute(node: PwNode): void {
    if (node?.ready && node?.audio) {
      node.audio.muted = !node.audio.muted;
    }
  }

  function setDefaultNode(node: PwNode): void {
    if (node?.isSink && node?.audio) {
      console.log("Setting Audio Sink" + node.description)
      Pipewire.preferredDefaultAudioSink = node;
    }
    else if (node?.isSink) {
      console.log("Setting Audio Source")
      Pipewire.preferredDefaultAudioSource = node;
    }
  }

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource, ]
  }
}
