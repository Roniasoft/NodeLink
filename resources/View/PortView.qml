import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * Port view draw a port on the node based on Port model.
 * ************************************************************************************************/

Rectangle {

    /* Property Declarations
    * ****************************************************************************************/
    property Port port

    /* Object Properties
     * ****************************************************************************************/
    x: port.x
    y: port.y

    width: 10
    height: width
    radius: width
    color: port.color

}
