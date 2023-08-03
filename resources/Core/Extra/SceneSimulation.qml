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

    //! Simulation Enability
    property bool simulationEnabled:  false

    //! Error message
    property string errorString: ""

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
    property var    nextNodes:          Object.values(nodes).filter(node => node?.status !== NotionNode.NodeStatus.Inactive)
                                                            .map(node => node._qsUuid);

    property Node parentNode: null

    //! map<current node uuid, parent node uuid>
    property var previousNodes: ({})

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

    onSimulationEnabledChanged: {
        if(simulationEnabled)
            reset();
    }

    //! Evaluates the next possible nodes
    function evaluate() {
        if (scene === null || node === null)
            return;

        //! InActive all active nodes
        var activeNodes = Object.values(nodes).filter(node => node?.status === NotionNode.NodeStatus.Active);
        activeNodes.forEach(node => {
                                console.log(node?.status)
                                node?.updateNodeStatus(NotionNode.NodeStatus.Inactive)
                            });


        //! Find last selected node and change it's status into Active
        var parentNode = Object.values(nodes).find(node => node?.status === NotionNode.NodeStatus.Selected);
        parentNode?.updateNodeStatus(NotionNode.NodeStatus.Active);

        console.log(node._qsUuid, node?.status);
        //! Update selected node status
        node?.updateNodeStatus(NotionNode.NodeStatus.Selected);

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
        nodeLinks.forEach(link => {
            // Find downstream NodeId/Node
            var downNode = scene.findNode(link.outputPort._qsUuid);

            // When node is transient, the node data must be used instead original node.
            if(downNode?.type === NLSpec.NodeType.Transition) {
                var transientTo = scene.findNodeId(downNode?.nodeData?.data);
                if(transientTo)
                    downNode = transientTo;
            }

            console.log(downNode?.status);
            if (checkNodeEntryCondition(downNode)) {
                downNode?.updateNodeStatus(NotionNode.NodeStatus.Active);
            }  

        });

        //! Update previous nodes
        if (node._qsUuid !== (simulation?.parentNode?._qsUuid ?? "") &&
            previousNodes[simulation?.parentNode?._qsUuid] !== node._qsUuid)
            previousNodes[node._qsUuid] = simulation?.parentNode?._qsUuid ?? "";

        //! Active previousNodes
        Object.entries(previousNodes).forEach(([key, value]) => {
                       if (key === node._qsUuid) {
                               var parentNode = scene.nodes[value];
                               parentNode?.updateNodeStatus(NotionNode.NodeStatus.Active);
                           }
                       });

        //! update current node ad parent node of next selected node
        simulation.parentNode = node;
    }

    //! Check entry condition of node
    function checkNodeEntryCondition(node: Node) : bool {
        // Data type is Action.
        console.log(node, node?.status)
        var nodeConditions = node?.entryCondition?.conditions ?? [];
        var nodeEntryConditionRes = true;
        nodeConditions.forEach(nodeCondition => {
            if (activatedActions.indexOf(nodeCondition) == -1) {
                nodeEntryConditionRes = false
            }
        });

        return nodeEntryConditionRes;
    }

    //! Reset Simulation
    function reset() {
        scene.selectionModel.clear();
        //! Find root nodes
        var rootNodes = nodes.filter(node => node.type === NLSpec.NodeType.Root);
        var rootNodeCount = rootNodes.length;
        //! Select only one root node.
        if (rootNodeCount !== 1) {
            errorString = "The simulation process cannot start, " +
             (rootNodeCount === 0 ? "You need a ROOT node." :
                "You need to delete the extra ROOT nodes")
            console.assert(errorString);

            simulationEnabled = false;
            return;
        }

        scene.selectionModel.selectNode(rootNodes[0]);

        //! InActive all nodes
        Object.values(nodes).forEach(node => node?.updateNodeStatus(NotionNode.NodeStatus.Inactive))

        evaluatedNodes = [];
        evaluatedNodesChanged();

        activatedActions = [];
        activatedActionsChanged();

        nextNodes = [];
        nextNodesChanged();
        errorString = "";

        // Reset previousNodes map
        parentNode = null;
        previousNodes = ({});
        previousNodesChanged();
    }
}
