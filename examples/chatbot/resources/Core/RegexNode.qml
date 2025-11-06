import QtQuick

import Chatbot

OperationNode {
    operationType: CSpecs.OperationType.Regex

    function updataData() {
        if (!nodeData.inputFirst) {
            nodeData.data = ""
            return
        }

        var re = /hello/i
        var found = re.test(nodeData.inputFirst)
        nodeData.data = found ? "FOUND" : "NOT_FOUND"
    }
}
