// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: clock
    spacing: 0
    width: parent.width / 2

    property int clockFontSize: 70


    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.top
        font.pointSize: 12
        font.family: config.Font
        color: config.ClockColor
        renderType: Text.QtRendering
        text: config.ClockHeaderText
        opacity: config.ClockOpacity
    }

    Label {
        id: timeLabel

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: -90

        font.pointSize: clockFontSize
        font.family: config.Font
        opacity: config.ClockOpacity

        font.bold: true
        color: config.ClockColor
        renderType: Text.QtRendering

        function updateTime() {
            text = new Date().toLocaleTimeString(Qt.locale(""), "HH:mm")
        }
    }

    Label {
        id: dateLabel

        anchors.horizontalCenter: parent.horizontalCenter
        
        color: config.ClockColor
        opacity: config.ClockOpacity

        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -33

        font.pointSize: 16
        font.family: config.Font
        font.bold: true
        renderType: Text.QtRendering

        function updateTime() {
            text = new Date().toLocaleDateString(Qt.locale(""), "dddd, d MMMM")
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            dateLabel.updateTime()
            timeLabel.updateTime()
        }
    }

    Component.onCompleted: {
        dateLabel.updateTime()
        timeLabel.updateTime()
    }
}
