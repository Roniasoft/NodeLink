import QtQuick
import ChatBot

OperationNode {
    operationType: CSpecs.OperationType.Regex

    function updataData(inputText) {
        if (!inputText) {
            nodeData.data = ""
            return
        }

        var re = /hello/i
        var found = re.test(inputText)
        nodeData.data = found ? "FOUND" : "NOT_FOUND"
    }
}
