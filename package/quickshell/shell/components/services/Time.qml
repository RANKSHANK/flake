pragma Singleton

import Quickshell
import QtQuick

import qs.vars

Singleton {
  id: root
  property alias enabled: clock.enabled
  readonly property alias date: clock.date
  readonly property alias hours: clock.hours
  readonly property alias minutes: clock.minutes
  readonly property alias seconds: clock.seconds

  property bool show: false

  function fmt(fmt: string): string {
    return Qt.formatDateTime(clock.date, fmt)
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  Timer {
    id: showtime
    interval: 1000
    repeat: true
    running: true
    onTriggered: {
      if (clock.seconds === 0 && clock.minutes % 5 === 0) {
        root.show = true
        hidetime.restart()
        if (clock.minutes === 0) {
          Sounds.clock60()
        } else if (clock.minutes % 15 === 0) {
          Sounds.clock15()
        } else if ((clock.minutes & 1) === 0) {
          Sounds.clock10()
        } else {
          Sounds.clock5()
        }
      }
    }
  }

  Timer {
    id: hidetime
    interval: 5000
    repeat: false
    onTriggered: {
      root.show = false
    }
  }
}
