import QtQuick
import QtQuick.Controls
import QtQuickStream
import NodeLink

/*! ***********************************************************************************************
 * Step node class: keep NotionNode proprties for Step node type.
 * ************************************************************************************************/

NotionNode {

    /* Object Properties
    * ****************************************************************************************/

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
