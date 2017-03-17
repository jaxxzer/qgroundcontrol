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

            // VEL parameters
            property Fact _velXYP:              controller.getParameterFact(-1, "RC_FEEL_RP")
            property Fact _velXYI:              controller.getParameterFact(-1, "r.ATC_RAT_RLL_P")
            property Fact _velXYIMax:           controller.getParameterFact(-1, "r.ATC_RAT_RLL_I")

            // POS parameters
            property Fact _posXYP:              controller.getParameterFact(-1, "r.ATC_RAT_PIT_P")

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
                id:         basicLabel
                text:       qsTr("Navigation Tuning")
                font.family: ScreenTools.demiboldFontFamily
            }

            Rectangle {
                id:                 basicTuningRect
                anchors.left:       parent.left
                anchors.right:      parent.right
                height:             basicTuningColumn.y + basicTuningColumn.height + _margins
                color:              palette.windowShade

                Column {
                    id:                 basicTuningColumn
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



                } // Column - Basic tuning
            } // Rectangle - Basic tuning


        } // Column
    } // Component
} // SetupView
