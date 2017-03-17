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

    property string _name
    property string _description
    height: sliderRow.height*1.1
    width: parent.width

    Row {
        id: sliderRow
        Column {
            QGCLabel {
                text:       _name
                font.family: ScreenTools.demiboldFontFamily
            }

            QGCLabel {
                text: _description
            }

            Slider {
                id:                 slide
                anchors.left:       parent.left
                anchors.right:      parent.right
                minimumValue:       _min
                maximumValue:       _max
                stepSize:           _increment
                tickmarksEnabled:   true
                width: parent.width

                onValueChanged: {
                        _param.value = _value
                }
            }
        }
    }

    Component.onCompleted: {
        _value = _param.value
        _name = _param.name
        _description = _param.shortDescription
    }
}
