import QtQuick              2.3
import QtQuick.Controls     1.2

import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.ScreenTools   1.0


Rectangle {
    property Fact _param
    property real _max: 10
    property real _min: 0
    property real _increment: 1
    property real _value

    property bool _loadComplete: false

    property string _name
    property string _description
    height: sliderColumn.height*1.1
    width: parent.width

    Component.onCompleted: {
        _value = _param.value
        _name = _param.name
        _max = _param.max
        _min = _param.min
        _increment = _param.increment
        _description = _param.shortDescription
        slide.minimumValue=      _min
        slide.maximumValue=       _max
        slide.value = _value

        _loadComplete = true
    }

    Column {
        id: sliderColumn
        width: parent.width

        QGCLabel {
            text:       _name
            font.family: ScreenTools.demiboldFontFamily
        }

        QGCLabel {
            text: _description
        }

        QGCLabel {
            text: slide.value.toFixed(2) + " " + _param.units
        }

        Slider {
            id:                 slide
            anchors.left:       parent.left
            anchors.right:      parent.right

            stepSize:           _increment
            tickmarksEnabled:   true
            width: parent.width

            onValueChanged: {
                if (_loadComplete) {
                    _param.value = value
                }
            }

            MouseArea {
                anchors.fill: parent
                onWheel: {
                    // do nothing
                    wheel.accepted = true;
                }
                onPressed: {
                    // propogate to ComboBox
                    mouse.accepted = false;
                }
                onReleased: {
                    // propogate to ComboBox
                    mouse.accepted = false;
                }
            }
        }
    }
}
