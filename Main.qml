// Copyright 2022 Alexey Varfolomeev <varlesh@gmail.com>
// Used sources & ideas:
// - Joshua Krämer from https://github.com/joshuakraemer/sddm-theme-dialog
// - Suraj Mandal from https://github.com/surajmandalcell/Elegant-sddm
// - Breeze theme by KDE Visual Design Group
// - SDDM Team https://github.com/sddm/sddm

import QtQuick 2.8
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4

import "components"

Rectangle {
    id: root
    width: 640
    height: 480
    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int selectedModelIndex: userModel.lastIndex
    property var currentIndex: userModel.lastIndex
    property int identifiquerOfChanges: 0
    property int identifiquerOfChanges2: 0
    property int iconSize: 30

    TextConstants {
        id: textConstants
    }

    function updateView() {
        // Alternar la visibilidad del elemento 'view'
        view.visible = !view.visible;
    }
    
    // hack for disable autostart QtQuick.VirtualKeyboard
    // Loader {
    //     id: inputPanel
    //     property bool keyboardActive: false
    //     source: "components/VirtualKeyboard.qml"
    // }

    FontLoader {
        id: fontbold
        source: "fonts/SFUIText-Semibold.otf"
    }
    
    Connections {
        target: sddm

        onLoginSucceeded: {

        }

        onLoginFailed: {
            password.placeholderText = textConstants.loginFailed
            password.placeholderTextColor = "white"
            password.text = ""
            errorMsgContainer.visible = true

            password.focus = true
        }
    }

    // Background Wallpaper
    Image {
        id: backgroundImage

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        Binding on source {
            when: config.Background !== undefined
            value: config.Background
        }
    }

    // Dim layer
    Rectangle {
        height: parent.height
        width: parent.width
        anchors.fill: parent
        
        color: config.DimBackgroundColor
        opacity: config.DimBackground
    }

    Row {
        spacing: 5

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.topMargin: 5

        Session {
            id: session
        }

        Rectangle {
            width: 30
            height: 30

            color: "transparent"

            Text {
                id: kb
                color: "#eff0f1"
                text: keyboard.layouts[keyboard.currentLayout].shortName
                font.pointSize: 10
                font.weight: Font.DemiBold

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        

        Button {
            image: "../images/system-suspend.svg"
            onClick: () => {
                sddm.suspend()
            }
        }

        Button {
            image: "../images/system-reboot.svg"
            onClick: () => {
                sddm.reboot()
            }
        }

        Button {
            image: "../images/system-shutdown.svg"
            onClick: () => {
                sddm.powerOff()
            }
        }
    }
    

    Clock {
        id: clock

        height: 260
        width: 400

        anchors.horizontalCenter: parent.horizontalCenter
        
        anchors.top: parent.top
        anchors.topMargin: 130
        
    }

    function fetchImagePath(username) {
        return "faces/" + username + ".png";
    }


    Item {
        width: 400
        height: 270
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        // Rectangle {
        //     id: dialog
        //     color: "transparent"
        //     height: 270
        //     width: 400
        // }

        Grid {
            columns: 1
            spacing: 8
            verticalItemAlignment: Grid.AlignVCenter
            horizontalItemAlignment: Grid.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: baseOfPath
                width: 150
                height: 150
                color: "transparent"

                Column {
                    
                    anchors.centerIn: parent
                    Item {
                        Rectangle {
                            id: mask
                            width: 85
                            height: 85
                            radius: 100
                            visible: false
                        }

                        DropShadow {
                            anchors.fill: mask
                            width: mask.width
                            height: mask.height
                            horizontalOffset: 0
                            verticalOffset: 0
                            radius: 8
                            samples: 10
                            color: "#40000000"
                            source: mask
                        }
                    }

                    Image {
                        id: ava
                        width: 86
                        height: 86
                        fillMode: Image.PreserveAspectCrop
                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: mask
                        }
                        source: fetchImagePath(user.currentText)
                        MouseArea {
                            id: mouseAreados
                            anchors.fill: parent
                            onClicked: {
                                if (view.visible === true) {
                                    view.visible = false
                            } else {
                                view.visible = true
                            }
                            enabled = false;
                                }
                        }

                    }

                }

                ComboBox {
                    id: user
                    height: 40
                    width: 226
                    textRole: "name"
                    currentIndex: userModel.lastIndex
                    model: userModel
                    visible: false
                }

                PathView {
                    id: view
                    anchors.fill: parent
                    highlight: appHighlight
                    currentIndex: userModel.lastIndex
                    preferredHighlightBegin: 0.5
                    preferredHighlightEnd: 0.5
                    // focus: true
                    model: userModel

                    visible: false

                    onVisibleChanged: {
                        mouseAreados.enabled = true;
                    }

                    path: Path {
                        startX: (baseOfPath.width+iconSize)/2; startY: 0

                        PathArc {
                            x: (baseOfPath.width+iconSize)/2; y: baseOfPath.height-(iconSize/2)
                            radiusX: 25; radiusY: 25
                            useLargeArc: true

                        }
                        PathPercent {value: (userModel.count < 5) ? 1.25 : (userModel.count < 9) ? 1 : .5 }

                        PathArc {
                            x: (baseOfPath.width+iconSize)/2; y: 0
                            radiusX: 25; radiusY: 25
                            useLargeArc: true

                        }
                        PathPercent {value: (userModel.count > 9) ? .5 :  0 }
                    }

                    delegate: Item {
                        id: icsSize
                        width: iconSize
                        height: iconSize

                        Rectangle {
                            
                            width: parent.width
                            height: parent.height
                            radius: width/2

                            Rectangle {
                                id: maskmenu
                                width: parent.width
                                height: parent.height
                                radius: parent.radius
                                color: "black"
                                visible: false
                                z: 0
                            }

                            Image {
                                id: profileImage

                                source: fetchImagePath(model.name)
                                anchors.fill: parent
                                fillMode: Image.PreserveAspectFit
                                z: 1
                                layer.enabled: true
                                    layer.effect: OpacityMask {
                                    maskSource: maskmenu
                                }
                            }


                            Text {
                                id: username
                                anchors.left: profileImage.right
                                anchors.verticalCenter: profileImage.verticalCenter
                                anchors.leftMargin: 5
                                // font.pixelSize: tooltip.height/2
                                text: model.name
                                color: "white"
                                layer.effect: DropShadow {
                                    horizontalOffset: 1
                                    verticalOffset: 1
                                    radius: 5
                                    samples: 25
                                    color: "#40000000"
                                }
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true

                                onEntered: {
                                    // tooltip.visible = true;
                                }

                                onExited: {
                                    // Ocultar el elemento al dejar de pasar el puntero
                                    // tooltip.visible = false;
                                }

                                onClicked: {
                                    userModel.selectedModelIndex = index;
                                    ava.source = fetchImagePath(model.name);
                                    usernametext.text = model.name;
                                    view.visible = (view.visible === true) ? false: true
                                }
                            }
                        }

                    }
                }

                Text {
                    id: usernametext
                    text: user.currentText
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 20
                    font.family: fontbold.name
                    font.weight: Font.DemiBold
                    color: "white"
                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 1
                        verticalOffset: 1
                        radius: 10
                        samples: 25
                        color: "#26000000"
                    }
                }

                
            }


            TextField {
                id: password

                height: 32
                width: 140
                color: "#fff"
                focus: true
                echoMode: TextInput.Password
                placeholderText: "Enter Pass" // textConstants.password
                font.pointSize: 8
                font.bold: true

                horizontalAlignment: TextInput.AlignHCenter

                function login() {
                    console.log("Login requests with user: " + user.currentText + " session: " + session.currentIndex)
                    sddm.login(user.currentText, password.text, session.currentIndex)
                }

                onAccepted: login()

                Keys.onReturnPressed: login()

                Component.onCompleted: {
                    password.forceActiveFocus()
                }

                background: Rectangle {
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    color: "#fff"
                    opacity: 0.2
                    radius: 15
                }

                Image {
                    id: caps
                    width: 24
                    height: 24
                    opacity: 0
                    state: keyboard.capsLock ? "activated" : ""
                    anchors.right: password.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10
                    fillMode: Image.PreserveAspectFit
                    source: "images/capslock.svg"
                    sourceSize.width: 24
                    sourceSize.height: 24

                    states: [
                        State {
                            name: "activated"
                            PropertyChanges {
                                target: caps
                                opacity: 1
                            }
                        },
                        State {
                            name: ""
                            PropertyChanges {
                                target: caps
                                opacity: 0
                            }
                        }
                    ]

                    transitions: [
                        Transition {
                            to: "activated"
                            NumberAnimation {
                                target: caps
                                property: "opacity"
                                from: 0
                                to: 1
                                duration: imageFadeIn
                            }
                        },

                        Transition {
                            to: ""
                            NumberAnimation {
                                target: caps
                                property: "opacity"
                                from: 1
                                to: 0
                                duration: imageFadeOut
                            }
                        }
                    ]
                }
            }

            // Label {
            //     id: greetingLabel

            //     anchors.topMargin: 30

            //     text: "Enter Pass"
            //     color: "#fff"
            //     style: softwareRendering ? Text.Outline : Text.Normal
            //     styleColor: softwareRendering ? ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
            //     font.pointSize: 6
            //     Layout.alignment: Qt.AlignHCenter
            //     font.family: config.font
            //     font.bold: true
            // }

        
        }
    }
}
