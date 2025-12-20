import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components.panes
import qs.vars

Scope {

  BasePane {

    id: pane


    name: Globals.namespace("background")

    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Background
    color: "transparent"

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true


  }

}
