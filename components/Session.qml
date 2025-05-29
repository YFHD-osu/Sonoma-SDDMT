import QtQuick 2.8
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4

ComboBox {
    height: 30

    model: sessionModel
    currentIndex: model.lastIndex
    textRole: "name"

    hoverEnabled: true

    contentItem: Row {
        spacing: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left

        Rectangle {
            width: 2.5
            height: 1
            color: "transparent"
        }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: "../images/conf.svg"
        }

        Text {
            text: session.displayText
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
            color: "#FFFFFF"
            elide: Text.ElideRight
        }

        Rectangle {
            width: 2.5
            height: 1
            color: "transparent"
        }
    }


    background: Rectangle {
        width: parent.width
        implicitWidth: parent.width
        implicitHeight: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#5655d4"

        radius: 5
    }


    delegate: MenuItem {
        id: menuitems
        width: parent.width

        highlighted: session.highlightedIndex === index
        hoverEnabled: session.hoverEnabled

        contentItem: Text {

            text: session.textRole
                ? (Array.isArray(session.model) ? modelData[session.textRole] : model[session.textRole])
                : modelData
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pixelSize: 12
            color: menuitems.highlighted ? "#ffffff" : "#cccccc"  // ✅ 根據選取改變文字色
            elide: Text.ElideRight
        }

        background: Rectangle {
            color: menuitems.highlighted ? "#3A80FF" : "transparent"  // 選取時與預設背景色
            radius: 3                                             // ✅ 圓角
            width: parent.width - 10
            anchors.horizontalCenter: parent.horizontalCenter
        }

        onClicked: {
            session.currentIndex = index
            slistview.currentIndex = index
            session.popup.close()
        }
    }

    indicator {
        visible: false
    }

    popup: Popup {
        width: parent.width
        implicitHeight: slistview.contentHeight
        y: session.height + 5

        padding: 5

        // ✅ 改變整個 popup 背景色
        background: Rectangle {
            color: "#1E1E1E" // 你想要的顏色，例如深灰色
            radius: 4
            opacity: 0.7
        }

        contentItem: ListView {
            id: slistview
            clip: true
            anchors.fill: parent
            model: session.model
            spacing: 2.5  // optional: 增加垂直間距
            highlightFollowsCurrentItem: true
            currentIndex: session.highlightedIndex
            delegate: session.delegate
            header: Item { height: 5; width: 1 }
            footer: Item { height: 5; width: 1 }
        }
    }

}