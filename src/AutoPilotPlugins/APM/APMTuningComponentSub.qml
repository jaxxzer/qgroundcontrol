/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick              2.3
import QtQuick.Controls     1.2

import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0

SetupPage {
    id:             tuningPage
    pageComponent:  tuningPageComponent

    Component {
        id: tuningPageComponent

        Column {
            width:      availableWidth
            spacing:    _margins
            FactPanelController { id: controller; factPanel: tuningPage.viewPanel }

            QGCPalette { id: palette; colorGroupEnabled: true }

            // POS parameters
            property Fact _posXY_P:              controller.getParameterFact(-1, "POS_XY_P")
            property Fact _posZ_P:              controller.getParameterFact(-1, "POS_Z_P")

            // VEL parameters
            property Fact _velXY_I:              controller.getParameterFact(-1, "VEL_XY_I")
            property Fact _velXY_IMax:           controller.getParameterFact(-1, "VEL_XY_IMAX")
            property Fact _velXY_P:             controller.getParameterFact(-1, "VEL_XY_P")
            property Fact _velZ_P:              controller.getParameterFact(-1, "VEL_Z_P")


            // WPNAV parameters
            property Fact _wpnavAccel:          controller.getParameterFact(-1, "WPNAV_ACCEL")
            property Fact _wpnavAccelZ:         controller.getParameterFact(-1, "WPNAV_ACCEL_Z")
            property Fact _wpnavLoitJerk:       controller.getParameterFact(-1, "WPNAV_LOIT_JERK")
            property Fact _wpnavLoitMaxA:       controller.getParameterFact(-1, "WPNAV_LOIT_MAXA")
            property Fact _wpnavLoitMinA:       controller.getParameterFact(-1, "WPNAV_LOIT_MINA")
            property Fact _wpnavLoitSpeed:      controller.getParameterFact(-1, "WPNAV_LOIT_SPEED")
            property Fact _wpnavRadius:         controller.getParameterFact(-1, "WPNAV_RADIUS")
            property Fact _wpnavSpeed:          controller.getParameterFact(-1, "WPNAV_SPEED")
            property Fact _wpnavSpeedDown:      controller.getParameterFact(-1, "WPNAV_SPEED_DN")
            property Fact _wpnavSpeedUp:        controller.getParameterFact(-1, "WPNAV_SPEED_UP")

            property real _margins: ScreenTools.defaultFontPixelHeight

            property bool _loadComplete: false

            Component.onCompleted: {
                // Qml Sliders have a strange behavior in which they first set Slider::value to some internal
                // setting and then set Slider::value to the bound properties value. If you have an onValueChanged
                // handler which updates your property with the new value, this first value change will trash
                // your bound values. In order to work around this we don't set the values into the Sliders until
                // after Qml load is done. We also don't track value changes until Qml load completes.
                _loadComplete = true
            }

            QGCLabel {
                text:       qsTr("Navigation Tuning")
                font.family: ScreenTools.demiboldFontFamily
            }


            Rectangle {
                anchors.left:       parent.left
                anchors.right:      parent.right
                height:             posColumn.height + _margins
                color:              palette.windowShade

                QGCLabel {
                    text: qsTr("POS")
                    font.family: ScreenTools.demiboldFontFamily
                }

                Column {
                    id: posColumn
                    anchors.margins:    _margins
                    anchors.left:       parent.left
                    anchors.right:      parent.right
                    anchors.top:        parent.top
                    spacing:            _margins

                    QGCParamSlider { _param: _posXY_P }
                    QGCParamSlider { _param: _posZ_P }
                } // Column - POS parameters
            } // Rectangle - POS parameters

            Rectangle {
                anchors.left:       parent.left
                anchors.right:      parent.right
                height:             velColumn.height + _margins
                color:              palette.windowShade

                QGCLabel {
                    text: qsTr("VEL")
                    font.family: ScreenTools.demiboldFontFamily
                }

                Column {
                    id: velColumn
                    anchors.margins:    _margins
                    anchors.left:       parent.left
                    anchors.right:      parent.right
                    anchors.top:        parent.top
                    spacing:            _margins

                    QGCParamSlider { _param: _velXY_I }
                    QGCParamSlider { _param: _velXY_IMax }
                    QGCParamSlider { _param: _velXY_P }
                    QGCParamSlider { _param: _velZ_P }
                } // Column - VEL parameters
            } // Rectangle - VEL parameters

            Rectangle {
                anchors.left:       parent.left
                anchors.right:      parent.right
                height:             wpnavColumn.height + _margins
                color:              palette.windowShade

                QGCLabel {
                    text: qsTr("WPNAV")
                    font.family: ScreenTools.demiboldFontFamily
                }

                Column {
                    id:                 wpnavColumn
                    anchors.margins:    _margins
                    anchors.left:       parent.left
                    anchors.right:      parent.right
                    anchors.top:        parent.top
                    spacing:            _margins

                    QGCParamSlider { _param: _wpnavAccel }
                    QGCParamSlider { _param: _wpnavAccelZ }
                    QGCParamSlider { _param: _wpnavLoitJerk }
                    QGCParamSlider { _param: _wpnavLoitMaxA }
                    QGCParamSlider { _param: _wpnavLoitMinA }
                    QGCParamSlider { _param: _wpnavLoitSpeed }
                    QGCParamSlider { _param: _wpnavRadius }
                    QGCParamSlider { _param: _wpnavSpeed }
                    QGCParamSlider { _param: _wpnavSpeedDown }
                    QGCParamSlider { _param: _wpnavSpeedUp }
                } // Column - WPNAV parameters
            } // Rectangle - WPNAV parameters
        } // Column
    } // Component
} // SetupView
