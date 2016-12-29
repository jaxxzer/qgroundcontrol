/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick              2.5
import QtQuick.Controls     1.2

import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0

SetupPage {
    id:                 subFramePage
    pageComponent:      subFramePageComponent

    Component {
        id: subFramePageComponent

        Column {
            id:     mainColumn
            width:      availableWidth

            FactPanelController { id: controller; factPanel: subFramePage.viewPanel }

            QGCPalette { id: palette; colorGroupEnabled: true }

            property Fact _frameConfig:         controller.getParameterFact(-1, "FRAME_CONFIG")

            function setFrameConfig(frame) {
                _frameConfig.value = frame;
            }

            property real _minW:        ScreenTools.defaultFontPixelWidth * 30
            property real _boxWidth:    _minW
            property real _boxSpace:    ScreenTools.defaultFontPixelWidth

            readonly property real spacerHeight: ScreenTools.defaultFontPixelHeight

            onWidthChanged: {
                computeDimensions()
            }

            Component.onCompleted: computeDimensions()

            function computeDimensions() {
                var sw  = 0
                var rw  = 0
                var idx = Math.floor(mainColumn.width / (_minW + ScreenTools.defaultFontPixelWidth))
                if(idx < 1) {
                    _boxWidth = mainColumn.width
                    _boxSpace = 0
                } else {
                    _boxSpace = 0
                    if(idx > 1) {
                        _boxSpace = ScreenTools.defaultFontPixelWidth
                        sw = _boxSpace * (idx - 1)
                    }
                    rw = mainColumn.width - sw
                    _boxWidth = rw / idx
                }
            }

//            ListModel {
//                id: subFrameModel

//                ListElement {
//                    name: "BlueROV2/Vectored"
//                    resource:
//                }
//            }

            Flow {
                id:         flowView
                width:      parent.width
                spacing:    _boxSpace

                Rectangle {
                    width:  _boxWidth
                    height: ScreenTools.defaultFontPixelHeight * 14
                    color:  qgcPal.window

                    QGCLabel {
                        id:     title0
                        text:   "BlueROV2/Vectored"
                    }

                    Rectangle {
                        readonly property int frameID: 0

                        anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 2
                        anchors.top:        title0.bottom
                        anchors.bottom:     parent.bottom
                        anchors.left:       parent.left
                        anchors.right:      parent.right
                        color:              frameID == _frameConfig.value ? qgcPal.buttonHighlight : qgcPal.windowShade

                        Image {
                            anchors.margins:    ScreenTools.defaultFontPixelWidth
                            anchors.top:        parent.top
                            anchors.bottom:     parent.bottom
                            anchors.left:       parent.left
                            anchors.right:      parent.right
                            fillMode:           Image.PreserveAspectFit
                            smooth:             true
                            mipmap:             true
                            source:             "qrc:///qmlimages/Frames/Vectored.png"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: setFrameConfig(parent.frameID)
                        }
                    }
                }

                Rectangle {
                    width:  _boxWidth
                    height: ScreenTools.defaultFontPixelHeight * 14
                    color:  qgcPal.window

                    QGCLabel {
                        id:     title1
                        text:   "BlueROV2/Vectored"
                    }

                    Rectangle {
                        readonly property int frameID: 0

                        anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 2
                        anchors.top:        title1.bottom
                        anchors.bottom:     parent.bottom
                        anchors.left:       parent.left
                        anchors.right:      parent.right
                        color:              frameID == _frameConfig.value ? qgcPal.buttonHighlight : qgcPal.windowShade

                        Image {
                            anchors.margins:    ScreenTools.defaultFontPixelWidth
                            anchors.top:        parent.top
                            anchors.bottom:     parent.bottom
                            anchors.left:       parent.left
                            anchors.right:      parent.right
                            fillMode:           Image.PreserveAspectFit
                            smooth:             true
                            mipmap:             true
                            source:             "qrc:///qmlimages/Frames/Vectored.png"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: setFrameConfig(parent.frameID)
                        }
                    }
                }

                Rectangle {
                    width:  _boxWidth
                    height: ScreenTools.defaultFontPixelHeight * 14
                    color:  qgcPal.window

                    QGCLabel {
                        id:     title1
                        text:   "BlueROV2/Vectored"
                    }

                    Rectangle {
                        readonly property int frameID: 0

                        anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 2
                        anchors.top:        title1.bottom
                        anchors.bottom:     parent.bottom
                        anchors.left:       parent.left
                        anchors.right:      parent.right
                        color:              frameID == _frameConfig.value ? qgcPal.buttonHighlight : qgcPal.windowShade

                        Image {
                            anchors.margins:    ScreenTools.defaultFontPixelWidth
                            anchors.top:        parent.top
                            anchors.bottom:     parent.bottom
                            anchors.left:       parent.left
                            anchors.right:      parent.right
                            fillMode:           Image.PreserveAspectFit
                            smooth:             true
                            mipmap:             true
                            source:             "qrc:///qmlimages/Frames/Vectored.png"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: setFrameConfig(parent.frameID)
                        }
                    }
                }

                Rectangle {
                    width:  _boxWidth
                    height: ScreenTools.defaultFontPixelHeight * 14
                    color:  qgcPal.window

                    QGCLabel {
                        id:     title1
                        text:   "BlueROV2/Vectored"
                    }

                    Rectangle {
                        readonly property int frameID: 0

                        anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 2
                        anchors.top:        title1.bottom
                        anchors.bottom:     parent.bottom
                        anchors.left:       parent.left
                        anchors.right:      parent.right
                        color:              frameID == _frameConfig.value ? qgcPal.buttonHighlight : qgcPal.windowShade

                        Image {
                            anchors.margins:    ScreenTools.defaultFontPixelWidth
                            anchors.top:        parent.top
                            anchors.bottom:     parent.bottom
                            anchors.left:       parent.left
                            anchors.right:      parent.right
                            fillMode:           Image.PreserveAspectFit
                            smooth:             true
                            mipmap:             true
                            source:             "qrc:///qmlimages/Frames/Vectored.png"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: setFrameConfig(parent.frameID)
                        }
                    }
                }

                Rectangle {
                    width:  _boxWidth
                    height: ScreenTools.defaultFontPixelHeight * 14
                    color:  qgcPal.window

                    QGCLabel {
                        id:     title1
                        text:   "BlueROV2/Vectored"
                    }

                    Rectangle {
                        readonly property int frameID: 0

                        anchors.topMargin:  ScreenTools.defaultFontPixelHeight / 2
                        anchors.top:        title1.bottom
                        anchors.bottom:     parent.bottom
                        anchors.left:       parent.left
                        anchors.right:      parent.right
                        color:              frameID == _frameConfig.value ? qgcPal.buttonHighlight : qgcPal.windowShade

                        Image {
                            anchors.margins:    ScreenTools.defaultFontPixelWidth
                            anchors.top:        parent.top
                            anchors.bottom:     parent.bottom
                            anchors.left:       parent.left
                            anchors.right:      parent.right
                            fillMode:           Image.PreserveAspectFit
                            smooth:             true
                            mipmap:             true
                            source:             "qrc:///qmlimages/Frames/Vectored.png"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: setFrameConfig(parent.frameID)
                        }
                    }
                }


            }
        } // Column
    } // Component
} // SetupPage
