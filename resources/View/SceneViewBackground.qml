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
        while(icounter * 20 <= viewWidth) {
            var jcounter = 0;
            while(jcounter * 20 <= viewHeigth) {
                privateVariable.points.push(Qt.point(icounter * 20,
                                     jcounter * 20));
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
            opacity: 0.5
            x: modelData.x
            y: modelData.y
        }
    }
}
