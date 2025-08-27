import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components.panes
import qs.vars

Loader {
  asynchronous: true

  sourceComponent: Variants {
    model: Quickshell.screens

    BubblePane {

    }
    // BasePane {
    //
    //   required property ShellScreen modeldata
    //   name: "background"
    //
    //   screen: modelData
    //
    //   anchors: {
    //     top: true
    //     bottom: true
    //     left: true
    //     right: true
    //   }
    //
    //   color: Theme.base04
    // }
  }
}

