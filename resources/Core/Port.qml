import QtQuick 2.15

QtObject {
    /* Property Declarations
     * ****************************************************************************************/

    // Related node id
    property string nodeID: "<unknown>"

    // Color of node
    property color color:   "white"

    // Port locations on the node
    property int x: 0
    property int y: 0

    // port side in node
    property int portSide: NLSpec.PortPositionSide.Top

    //Type of port, input or output
    property int portType: NLSpec.PortType.Input
}
