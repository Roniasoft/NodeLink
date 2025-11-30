import QtQuick

import NodeLink
import Chatbot

Node {
    type: CSpecs.NodeType.Regex
    nodeData: I_NodeData {}
    property var inputFirst: null
    property var matchedPattern: null
    guiConfig.width: 150
    guiConfig.height: 100

    Component.onCompleted: addPorts();

    function addPorts () {
        let _port1 = NLCore.createPort();
        let _port2 = NLCore.createPort();
        let _port3 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Input
        _port1.portSide = NLSpec.PortPositionSide.Left
        _port1.enable   = false;
        _port1.title    = "input";

        _port2.portType = NLSpec.PortType.Output
        _port2.portSide = NLSpec.PortPositionSide.Right
        _port2.title    = "output 1";

        _port3.portType = NLSpec.PortType.Output
        _port3.portSide = NLSpec.PortPositionSide.Right
        _port3.title    = "output 2";

        addPort(_port1);
        addPort(_port2);
        addPort(_port3);
    }

    function updataData() {
        if (!inputFirst) {
            return
        }

        // Check if nodeData.data is valid
        if (!nodeData || !nodeData.data || typeof nodeData.data !== 'string') {
            matchedPattern = "NOT_FOUND"
            return
        }

        try {
            var re = new RegExp(nodeData.data, "i")
            var found = re.test(inputFirst)
            matchedPattern = found ? "FOUND" : "NOT_FOUND"
        } catch (e) {
            // Invalid regex pattern
            console.warn("RegexNode: Invalid regular expression:", nodeData.data, e)
            matchedPattern = "NOT_FOUND"
        }
    }
}
