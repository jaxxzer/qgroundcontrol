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
            width:      availableWidth
            height:     availableHeight

            FactPanelController { id: controller; factPanel: subFramePage.viewPanel }

            QGCPalette { id: palette; colorGroupEnabled: true }

            property Fact _frameConfig:         controller.getParameterFact(-1, "FRAME_CONFIG")

            function setFrameConfig(frame) {
                _frameConfig.value = frame;
            }

            Flow {
                anchors.topMargin:  ScreenTools.defaultFontPixelWidth
                anchors.left:       parent.left
                anchors.right:      parent.right
                spacing:            ScreenTools.defaultFontPixelWidth
                width:              parent.width
                height:             parent.height

                Rectangle {
                    readonly property int frameID: 2
                    width:          (parent.width - 2 * ScreenTools.defaultFontPixelWidth)/3
                    height:         (parent.height - ScreenTools.defaultFontPixelWidth)/2
                    border.color: frameID == _frameConfig.value ? "green" : "transparent"
                    border.width: 5

                    Image {
                        width:          parent.width - parent.border.width*2 - frameLabel.height
                        height:         parent.height - parent.border.width*2 - frameLabel.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        sourceSize.width:   width
                        source:        "qrc:///qmlimages/Frames/Vectored.png"
                        fillMode:       Image.PreserveAspectFit
                    }

                    QGCLabel {
                        id:                     frameLabel
                        width:                  parent.width
                        horizontalAlignment:    Text.AlignHCenter
                        anchors.bottom:         parent.bottom
                        font.pointSize:         ScreenTools.mediumFontPointSize
                        text:                   qsTr("BlueROV2/Vectored Frame")
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: setFrameConfig(parent.frameID)
                    }
                }


                Rectangle {
                    readonly property int frameID: 3
                    width:          (parent.width - 2 * ScreenTools.defaultFontPixelWidth)/3
                    height:         (parent.height - ScreenTools.defaultFontPixelWidth)/2
                    border.color: frameID == _frameConfig.value ? "green" : "transparent"
                    border.width: 5

                    Image {
                        width:          parent.width - parent.border.width*2 - frameLabel.height
                        height:         parent.height - parent.border.width*2 - frameLabel.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        sourceSize.width:   width
                        source:        "qrc:///qmlimages/Frames/Vectored6DOF.png"
                        fillMode:       Image.PreserveAspectFit
                    }

                    QGCLabel {
                        width:                  parent.width
                        horizontalAlignment:    Text.AlignHCenter
                        anchors.bottom:         parent.bottom
                        font.pointSize:         ScreenTools.mediumFontPointSize
                        text:                   qsTr("Vectored 6DOF Frame")
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: setFrameConfig(parent.frameID)
                    }
                }


                Rectangle {
                    readonly property int frameID: 0
                    width:          (parent.width - 2 * ScreenTools.defaultFontPixelWidth)/3
                    height:         (parent.height - ScreenTools.defaultFontPixelWidth)/2
                    border.color: frameID == _frameConfig.value ? "green" : "transparent"
                    border.width: 5

                    Image {
                        width:          parent.width - parent.border.width*2 - frameLabel.height
                        height:         parent.height - parent.border.width*2 - frameLabel.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        sourceSize.width:   width
                        source:        "qrc:///qmlimages/Frames/BlueROV1.png"
                        fillMode:       Image.PreserveAspectFit
                    }

                    QGCLabel {
                        width:                  parent.width
                        horizontalAlignment:    Text.AlignHCenter
                        anchors.bottom:         parent.bottom
                        font.pointSize:         ScreenTools.mediumFontPointSize
                        text:                   qsTr("BlueROV1 Frame")
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: setFrameConfig(parent.frameID)
                    }
                }


                Rectangle {
                    readonly property int frameID: 1
                    width:          (parent.width - 2 * ScreenTools.defaultFontPixelWidth)/3
                    height:         (parent.height - ScreenTools.defaultFontPixelWidth)/2
                    border.color: frameID == _frameConfig.value ? "green" : "transparent"
                    border.width: 5

                    Image {
                        width:          parent.width - parent.border.width*2 - frameLabel.height
                        height:         parent.height - parent.border.width*2 - frameLabel.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        sourceSize.width:   width
                        source:        "qrc:///qmlimages/Frames/SimpleROV-3.png"
                        fillMode:       Image.PreserveAspectFit
                    }

                    QGCLabel {
                        width:                  parent.width
                        horizontalAlignment:    Text.AlignHCenter
                        anchors.bottom:         parent.bottom
                        font.pointSize:         ScreenTools.mediumFontPointSize
                        text:                   qsTr("SimpleROV Frame")
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: setFrameConfig(parent.frameID)
                    }
                }


                Rectangle {
                    readonly property int frameID: 1
                    width:          (parent.width - 2 * ScreenTools.defaultFontPixelWidth)/3
                    height:         (parent.height - ScreenTools.defaultFontPixelWidth)/2
                    border.color: frameID == _frameConfig.value ? "green" : "transparent"
                    border.width: 5

                    Image {
                        width:          parent.width - parent.border.width*2 - frameLabel.height
                        height:         parent.height - parent.border.width*2 - frameLabel.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        sourceSize.width:   width
                        source:        "qrc:///qmlimages/Frames/SimpleROV-4.png"
                        fillMode:       Image.PreserveAspectFit
                    }

                    QGCLabel {
                        width:                  parent.width
                        horizontalAlignment:    Text.AlignHCenter
                        anchors.bottom:         parent.bottom
                        font.pointSize:         ScreenTools.mediumFontPointSize
                        text:                   qsTr("SimpleROV Frame")
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: setFrameConfig(parent.frameID)
                    }
                }


            }
        } // Column
    } // Component
} // SetupPage
