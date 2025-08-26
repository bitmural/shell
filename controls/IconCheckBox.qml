// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
// https://github.com/qt/qtdeclarative/blob/dev/src/quickcontrols/material/CheckBox.qml

import Quickshell
import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl
import QtQuick.VectorImage
import QtQuick.Effects

T.CheckBox {
  id: control

  property string iconSource

  implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                          implicitContentWidth + leftPadding + rightPadding)
  implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                           implicitContentHeight + topPadding + bottomPadding,
                           implicitIndicatorHeight + topPadding + bottomPadding)

  spacing: 3
  padding: 3
  verticalPadding: padding

  indicator: Rectangle {
      id: indicatorItem
      implicitWidth: 32
      implicitHeight: 32
      color: !control.enabled ? control.Material.hintTextColor
          : !control.hovered ? "transparent" : control.Material.rippleColor
      border.color: !control.enabled ? control.Material.hintTextColor
          : checkState === Qt.Unchecked ? control.Material.secondaryTextColor
          : !control.hovered ? control.Material.accentColor : Material.switchCheckedHandleColor
      border.width: checkState !== Qt.Unchecked ? width / 2 : 2
      radius: 2

      x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding + (control.availableWidth - width) / 2
      y: control.topPadding + (control.availableHeight - height) / 2

      property Item control: control
      property int checkState: control.checkState

      Behavior on border.width {
          NumberAnimation {
              duration: 100
              easing.type: Easing.OutCubic
          }
      }

      Behavior on border.color {
          ColorAnimation {
              duration: 100
              easing.type: Easing.OutCubic
          }
      }
      Behavior on color  {
        ColorAnimation {
            duration: 100
            easing.type: Easing.OutCubic
        }
      }

      VectorImage {
        id: checkImage
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 32
        height: 32
        source: control.iconSource
        fillMode: Image.PreserveAspectFit
        preferredRendererType: VectorImage.CurveRenderer
        layer.enabled: true
        layer.effect: MultiEffect {
          brightness: indicatorItem.checkState === Qt.Checked ? 1.0 : 0.3
          colorization: 1.0
          colorizationColor: Material.foreground }

        scale: indicatorItem.checkState === Qt.Checked ? 1 : .8
        Behavior on scale { NumberAnimation { duration: 100 } }
      }

      Rectangle {
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 12
        height: 3

        scale: indicatorItem.checkState === Qt.PartiallyChecked ? 1 : 0
        Behavior on scale { NumberAnimation { duration: 100 } }
      }

      states: [
        State {
          name: "checked"
          when: indicatorItem.checkState === Qt.Checked
        },
        State {
          name: "partiallychecked"
          when: indicatorItem.checkState === Qt.PartiallyChecked
        }
      ]

      transitions: Transition {
        SequentialAnimation {
          NumberAnimation {
            target: indicatorItem
            property: "scale"
            // Go down 2 pixels in size.
            to: 1 - 2 / indicatorItem.width
            duration: 120
          }
          NumberAnimation {
            target: indicatorItem
            property: "scale"
            to: 1
            duration: 120
          }
        }
      }

      // Ripple {
      //   x: (parent.width - width) / 2
      //   y: (parent.height - height) / 2
      //   width: 32; height: 32

      //   z: -1
      //   anchor: control
      //   pressed: control.pressed
      //   active: enabled && (control.down || control.visualFocus || control.hovered)
      //   color: control.checked ? control.Material.highlightedRippleColor : control.Material.rippleColor
      // }
  } //indicator


  contentItem: Text {
      leftPadding: control.indicator && !control.mirrored ? control.indicator.width + control.spacing : 0
      rightPadding: control.indicator && control.mirrored ? control.indicator.width + control.spacing : 0

      text: control.text
      font: control.font
      color: control.enabled ? control.Material.foreground : control.Material.hintTextColor
      elide: Text.ElideRight
      verticalAlignment: Text.AlignVCenter
  }
}
