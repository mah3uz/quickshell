pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string connection: "enp11s0"
    property string upIcon: ""
    property string downIcon: ""
    property string currentSpeed: "0.0B\n0.0B"

    function speed(): string {
        return currentSpeed
    }

    Process {
        id: speedMonitor
        running: true
        command: ["bash", "/home/mahfuz/.config/caelestia/utils/scripts/speedmonitor.sh", root.connection]
        
        stdout: StdioCollector {
            onStreamFinished: {
                console.log(`line read: ${this.text}`)
                var output = text.replace(":", "\n")
                
                if (output) {
                    root.currentSpeed = output
                }
            }
        }
    }

    // Timer to restart the process if it stops
    Timer {
        id: restartTimer
        interval: 1000
        repeat: true
        running: true
        
        onTriggered: {
            if (!speedMonitor.running) {
                speedMonitor.running = true
            }
        }
    }
}