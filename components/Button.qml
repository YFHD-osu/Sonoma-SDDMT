import QtQuick 2.8
import QtGraphicalEffects 1.0

Rectangle {
    id: interactiveRect
    width: 30
    height: 30
    color: hovered ? (pressed ? Qt.rgba(0.5, 0.5, 0.5, 0.5) : Qt.rgba(1, 1, 1, 0.3)) : "transparent"

    radius: 4

    property bool hovered: false
    property bool pressed: false

    property var onClick
    property string image

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: interactiveRect.hovered = true
        onExited: {
            interactiveRect.hovered = false
            interactiveRect.pressed = false
        }
        onPressed: {
          interactiveRect.pressed = true

          if (onClick) onClick();
        }
        onReleased: interactiveRect.pressed = false
    }

    Image {
        id: shutdown
        height: 21
        width: 21
        source: image
        fillMode: Image.PreserveAspectFit

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

}
