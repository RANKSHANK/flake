import Quickshell
import Quickshell.Wayland
import qs.vars

PanelWindow {
  required property string name

  WlrLayershell.namespace: Globals.namespace("background")
  color: "transparent"

}
