import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.components.panes
import qs.components.services
import qs.vars

Item {
  id: root
  BasePane {
    id: pane


    anchors.top: true

    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    visible: Time.show || Globals.focused

    implicitHeight: clock.implicitHeight
    implicitWidth: clock.implicitWidth

    color: Theme.backgroundUnfocused
    property int y: -100

    Text {
      id: clock

      horizontalAlignment: Text.AlignHCenter

      color: Theme.base05
      text: Time.fmt("dddd MMM dd\nhh:mm:ss")

    }

    NumberAnimation on y {
      from: -100
      to: 0
      duration: 100
      easing.type: Easing.OutQuad
    }

    NumberAnimation on y {
      from: 0
      to: -100
      duration: 100
      easing.type: Easing.InQuad
    }

    onVisibleChanged: {
      if (visible) {
        pane.y = -100;
        pane.y = 0;
      } else {
        pane.y = 0;
      }

    }
  }
}
