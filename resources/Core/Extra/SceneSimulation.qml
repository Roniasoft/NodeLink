import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * Simulation
 * ************************************************************************************************/

Item {
    id: simulation

    /* Property Declarations
     * ****************************************************************************************/

    //! Scene model, use to simulation
    required property Scene  scene

    //! Reference node of the simulation. Next possible nodes will be
    //! determined based on this reference node.
    required property Node   node

    //! Nodes Simulated
    //! array <node uuid>
    property var    evaluatedNodes:     []

    //! Active actions are stored while nodes are evaluating
    property var    activatedActions:   []

    //! Next available nodes for evaluation
    //! array <node uuid>
    property var    nextNodes:          []

    //! All nodes in selected Scene
    //! use nodes map in Scene model
    property var    nodes:              Object.values(scene?.nodes ?? ({}))

    //! All links in the scene
    property var    links:              Object.values(scene?.links ?? ({}))

    // watch for all actions active/inactive for current node
    Repeater {
        model: Object.values(node?.nodeData?.data ?? ({})) ?? []    // Actions
        enabled: node?.type === NLSpec.NodeType.Step ?? false
        delegate: Item {
            property Action action: modelData

            // check if the action is activate/inactivate then re-evaluate
            Connections {
                target: action
                function onActiveChanged() {
                    simulation.evaluate();
                }
            }
        }
    }


    /* Functions
     * ****************************************************************************************/

    //! When the node is changed, the simulation needs to be re-evaluted
    onNodeChanged: evaluate();

    //! Evaluates the next possible nodes
    function evaluate() {
        if (scene === null || node === null)
            return;

        nextNodes = [];
        nextNodesChanged();

        // Update evaluated nodes
        // while re-evaluating, the node shouldn't be added again
        if (evaluatedNodes.indexOf(node._qsUuid) == -1) {
            evaluatedNodes = evaluatedNodes.concat(node._qsUuid);
        }

        // Update activated actions if the node is a Step node
        if (node?.type === NLSpec.NodeType.Step) {
            var nodeActions = Object.values(node?.nodeData?.data) ?? [];

            nodeActions.forEach(action => {
                // if the action is active and not included then add it
                if (action.active && activatedActions.indexOf(action._qsUuid) == -1) {
                    activatedActions = activatedActions.concat(action._qsUuid)
                }

                // else if action is not active but is already included, then it should be deleted
                else if (!action.active && activatedActions.indexOf(action._qsUuid) >= 0) {
                    var removeActionIndex = activatedActions.indexOf(action._qsUuid);
                    activatedActions.splice(removeActionIndex, 1);
                    activatedActionsChanged();
                }
            });
        }


        // find links that their inputPort is located in this node
        // List <Link>
        var nodeLinks = links.filter(link => scene.findNodeId(link.inputPort._qsUuid) === node._qsUuid);

        // Find all downstream nodes
        // List<Node>
        var downstreamNodes = []
        nodeLinks.forEach(link => {
            // Find downstream NodeId/Node
            var downNodeId = scene.findNodeId(link.outputPort._qsUuid);
            var downNode = scene.nodes[downNodeId];

            // When node is transient, the node data must be used instead original node.
            if(downNode?.type === NLSpec.NodeType.Transition) {
                var transientTo = scene.findNodeId(downNode?.nodeData?.data)
                downNode = transientTo;
            }

            // Data type is Action.
            var nodeConditions = downNode?.entryCondition?.conditions ?? [];
            var entryConditionRes = true;
            nodeConditions.forEach(nodeCondition => {
                if (activatedActions.indexOf(nodeCondition) == -1) {
                    entryConditionRes = false
                }
            });
            if (entryConditionRes == true) {
                nextNodes.push(downNodeId);
                nextNodesChanged();
            }
        });
    }

    //! Reset Simulation
    function reset() {
        evaluatedNodes = [];
        evaluatedNodesChanged();

        activatedActions = [];
        activatedActionsChanged();

        nextNodes = [];
        nextNodesChanged();
    }
}
