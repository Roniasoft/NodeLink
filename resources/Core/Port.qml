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

    // port side in node
    property int portSide: NLSpec.PortPositionSide.Top

    //Type of port, input or output
    property int portType: NLSpec.PortType.Input
}
