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
    //! Simulation Enability types
    enum SimulationEnableType {
        Running = 0,
        Paused  = 1,
        Stopped = 2,

        Unknown = 99
    }

    //! Scene model, use to simulation
    required property Scene  scene

    //! Simulation Enability, Call reset before starting simulation (SceneSimulation.SimulationEnableType.Running)
    property int simulationEnabled:  SceneSimulation.SimulationEnableType.Stopped

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
    property var    activeNodes:          Object.values(nodes).filter(node => node?.status === NotionNode.NodeStatus.Active)
                                                            .map(node => node._qsUuid);

    property Node parentNode: null

    //! map<current node uuid, parent node uuid>
    property var previousNodes: ({})

    //! All nodes in selected Scene
    //! use nodes map in Scene model
    property var    nodes:              Object.values(scene?.nodes ?? ({}))

    //! All links in the scene
    property var    links:              Object.values(scene?.links ?? ({}))

    //! Zoom factor of selectede node.
    property real selectedNodeZoomFactor: 1.4

    /* Signals
    * ****************************************************************************************/

    //! zoomToNode manage zoom to node process in simulation mode.
    signal zoomToNode(node: Node, targetZoomFactor: real)

    //! Post a message from the simulation to the simulation logger
    signal postLog(simulationLog: string);

    /* Children
    * ****************************************************************************************/

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


    /* Slots
     * ****************************************************************************************/

    //! When the node is changed, the simulation needs to be re-evaluted
    onNodeChanged: {
        if (simulationEnabled === SceneSimulation.SimulationEnableType.Running)
            evaluate();
    }

    //! Update node selection after edit mode changed, if node was removed,
    //! We ignore it in selection.
    onSimulationEnabledChanged: {
        if (node && simulationEnabled === SceneSimulation.SimulationEnableType.Running) {
            //! Select only one root node.
            if (!checkSimulationCondition()) {
                return;
            }

            var nodeToSelect = node;
            if (!checkNodeEntryCondition(nodeToSelect)) {
                postLog("Can not select the last node.");
                var upstreamNodeToSelect = previousNodes[nodeToSelect._qsUuid];
                if (upstreamNodeToSelect.length !==0) {
                    nodeToSelect = nodes.find(node => node._qsUuid === upstreamNodeToSelect);
                }

                if(!checkNodeEntryCondition(nodeToSelect)) {
                    // Select root node
                    postLog("Select the ROOT node.");
                    nodeToSelect = nodes.find(node => node.type === NLSpec.NodeType.Root);
                    nodeToSelect?.updateNodeStatus(NotionNode.NodeStatus.Selected);
                }
            }

            scene.selectionModel.clearAllExcept(nodeToSelect._qsUuid)
            scene.selectionModel.selectNode(nodeToSelect);
        } else if (simulationEnabled === SceneSimulation.SimulationEnableType.Running)
            reset();
    }

    /* Functions
     * ****************************************************************************************/

    //! Evaluates the next possible nodes
    function evaluate() {
        if (!(scene && node)) {
            errorString = "Undefined ERROR";
            return;
        }

        //! when a node changed and checked some conditins, we zoom into selected node.
        zoomToNode(node, selectedNodeZoomFactor);

        //! InActive all active nodes
        var activeNodes = nodes.filter(node => node?.status === NotionNode.NodeStatus.Active);
        activeNodes.forEach(node =>
                                node?.updateNodeStatus(NotionNode.NodeStatus.Inactive)
                            );


        //! Find last selected node and change it's status into Active
        var parentNode = Object.values(nodes).find(node => node?.status === NotionNode.NodeStatus.Selected);
        parentNode?.updateNodeStatus(NotionNode.NodeStatus.Active);

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
        // Check node existence
        if(!Object.keys(scene.nodes).includes(node?._qsUuid ?? ""))
            return false

        // Data type is Action.
        var nodeConditions = node?.entryCondition?.conditions ?? [];
        var nodeEntryConditionRes = true;
        nodeConditions.forEach(nodeCondition => {
            if (activatedActions.indexOf(nodeCondition) == -1) {
                nodeEntryConditionRes = false
            }
        });

        return nodeEntryConditionRes;
    }

    //! Check simulation condition
    function checkSimulationCondition() : bool {
        //! Find root nodes
        var rootNodes = nodes.filter(node => node.type === NLSpec.NodeType.Root);
        var rootNodeCount = rootNodes.length;
        //! Select only one root node.
        if (rootNodeCount !== 1) {
            errorString = "The simulation process cannot start,"
                        + " Keep only one ROOT node."

            simulationEnabled = SceneSimulation.SimulationEnableType.Stopped;
            console.assert(errorString);
            return false;
        }

        return true;
    }

    //! Reset Simulation
    function reset() {
        scene.selectionModel.clear();
        errorString = "";

        //! Select only one root node.
        if (!checkSimulationCondition()) {
            return;
        }

        //! InActive all nodes
        nodes.forEach(node =>
                node?.updateNodeStatus(NotionNode.NodeStatus.Inactive)
            );

        // Select root node
        var rootNode = nodes.find(node => node.type === NLSpec.NodeType.Root);
        scene.selectionModel.selectNode(rootNode);
        rootNode?.updateNodeStatus(NotionNode.NodeStatus.Selected)


        evaluatedNodes = [];
        evaluatedNodesChanged();

        activatedActions = [];
        activatedActionsChanged();

        // Reset previousNodes map
        parentNode = null;
        previousNodes = ({});
        previousNodesChanged();

        // Reset simulation log
        postLog("The simulation process was reset.")
    }
}
