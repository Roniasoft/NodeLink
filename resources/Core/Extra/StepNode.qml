import QtQuick 2.15
import QtQuickStream
import NodeLink

Node {
    type: NLSpec.NodeType.Step
    nodeData: StepNodeData {}

    //! Add sample data
    Component.onCompleted: {
        for (var i = 0; i < 5; i++) {
            var newAction = nodeData.createAction();
            nodeData.addAction(newAction);
        }
    }
}
