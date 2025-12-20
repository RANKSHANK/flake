pragma Singleton
import Quickshell
import QtQuick

Singleton {
  readonly property string shellName: "venusComb"

  property bool focused: false

  function namespace(name) {
    return shellName + "-" + name;
  }
}
