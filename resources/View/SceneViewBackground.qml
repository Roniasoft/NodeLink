import QtQuick
import QtQuick.Controls

/*! ***********************************************************************************************
 * SceneViewBackground draw background of scene.
 * ************************************************************************************************/
Item {
    /* Property Declarations
    * ****************************************************************************************/
    property real viewWidth
    property real viewHeigth

    /* Private Property Declarations
     * ****************************************************************************************/
    QtObject {
        id: privateVariable
        property var points: []
    }

    /* Functions
     * ****************************************************************************************/
    onViewWidthChanged: calcuateGridSize();
    onViewHeigthChanged: calcuateGridSize();

    function calcuateGridSize() {
        privateVariable.points = [];
        var point;
        var icounter = 0;
        while(icounter * 10 <= viewWidth) {
            var jcounter = 0;
            while(jcounter * 10 <= viewHeigth) {
                privateVariable.points.push(Qt.point(icounter * 10,
                                     jcounter * 10));
                jcounter++;
            }
            icounter++;
        }
    }


    /* Children
    * ****************************************************************************************/
    Repeater {
        model: privateVariable.points
        delegate: Rectangle {
            height: 2
            width: 2
            color: "#333333"
            x: modelData.x
            y: modelData.y
        }
    }
}
