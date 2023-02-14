import QtQuick

QtObject {
    /* Property Declarations
     * ****************************************************************************************/

    // Port ID
    property string portID: "<unknown>"

    // Related node id
//    property Node parentNode

    // Color of node
    property color color:   "white"

    // Port locations on the node
    property int x: 0
    property int y: 0

    // Port locations on the global system
    property int gx: 0
    property int gy: 0

    // port side in node
    property int portSide: NLSpec.PortPositionSide.Top

    //Type of port, input or output
    property int portType: NLSpec.PortType.Input
}
