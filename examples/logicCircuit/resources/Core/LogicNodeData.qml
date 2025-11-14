import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * The LogicNodeData class for logic gate node data
 * ************************************************************************************************/
I_NodeData {
    //! Input values for logic gates
    property var inputA: null
    property var inputB: null

    //! Output value
    property var output: null

    //! For InputNode: current state (true=ON, false=OFF)
    property bool currentState: false

    //! For display purposes
    property string displayValue: "OFF"
}
