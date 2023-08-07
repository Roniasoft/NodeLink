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
    //! Edit Mode
    property bool editEnabled: simulationEnabled === SceneSimulation.SimulationEnableType.Paused;

    //! Zooms to the current node
    signal zoomToNode(node: Node, targetZoomFactor: real)

    //! Adds a new color to link color map (red & green links)
    signal linkColorAdd(id: string, chosenColor: string)

    //! Clears the color map entirely
    signal clearColorMap()

    //! Post a message from the simulation to the simulation logger
    signal postLog(simulationLog: string);

    /* Children
    * ****************************************************************************************/

    // watch for all actions active/inactive for selected node
    Repeater {
        model: Object.values(node?.nodeData?.data ?? ({})) ?? []    // Actions
        enabled: simulationEnabled === SceneSimulation.SimulationEnableType.Running && (node?.type === NLSpec.NodeType.Step ?? false)
        delegate: Item {
            property Action action: modelData

            // check if the action is activate/inactivate then re-evaluate
            Connections {
                target: action
                enabled: simulationEnabled === SceneSimulation.SimulationEnableType.Running
                function onActiveChanged() {
                    //Update activated actions
                    postLog(("\r\n Action " + action.name + (action.active ? " activated." : " inactivated.") + "\r\n"));
                    simulation.updateActivatedActions();
                    simulation.evaluate();
                    simulation.colorChange();
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
        colorChange();
    }

    //! Update node selection after edit mode changed, if node was removed,
    //! We ignore it in selection.
    onSimulationEnabledChanged: {
        if (node && simulationEnabled === SceneSimulation.SimulationEnableType.Running) {
            //! Select only one root node.
            if (!checkSimulationCondition()) {
                return;
            }

            simulation.updateActivatedActions();

            // Find upstream node
            var nodeToSelect = findNodeToSelect(node);

            var isNeedEvaluate = node._qsUuid === nodeToSelect._qsUuid;
            // Select node and evaluate it.
            scene.selectionModel.clearAllExcept(nodeToSelect._qsUuid);
            scene.selectionModel.selectNode(nodeToSelect);
            if (isNeedEvaluate)
                evaluate();

        } else if (simulationEnabled === SceneSimulation.SimulationEnableType.Running)
            reset();
    }

    onEditEnabledChanged: colorChange();
    /* Functions
     * ****************************************************************************************/

    //! Changed Links colors
    function colorChange() {
        clearColorMap()
        links.forEach (link => {
            if (scene.findNode(link.inputPort._qsUuid) === node && !editEnabled) {
                if (scene.findNode(link.outputPort._qsUuid).status === NotionNode.NodeStatus.Active
                        || scene.findNode(link.outputPort._qsUuid).status === NotionNode.NodeStatus.Selected) {
                    linkColorAdd(link._qsUuid, "green")
                }
                if (scene.findNode(link.outputPort._qsUuid).status === NotionNode.NodeStatus.Inactive) {
                    linkColorAdd(link._qsUuid, "red")
                }
            }
        });
    }

    //! Evaluates the next possible nodes
    function evaluate() {
        if (!(scene && node)) {
            errorString = "Undefined ERROR";
            return;
        }

        // Check entry condition and update selected node status
        // This happen when change activation action and
        // switch from edit mode.
        if (checkNodeEntryCondition(node))
            node?.updateNodeStatus(NotionNode.NodeStatus.Selected);
        else { // must not happened in any time
            var nodeToSelect = findNodeToSelect(node);
            scene.selectionModel.selectNode(nodeToSelect);
            scene.selectionModel.clearAllExcept(nodeToSelect._qsUuid);
            evaluate();
            return;
        }

        //! when a node changed and checked some conditins, we zoom into selected node.
        zoomToNode(node, selectedNodeZoomFactor);

        //! InActive all nodes except current selected node
        var activeNodes = nodes.filter(node => node?.status !== NotionNode.NodeStatus.Inactive);
        activeNodes.forEach(nodeObj => {
                            if (nodeObj._qsUuid !== node._qsUuid)
                                nodeObj?.updateNodeStatus(NotionNode.NodeStatus.Inactive);
                            });

        // Update evaluated nodes
        // while re-evaluating, the node shouldn't be added again
        if (evaluatedNodes.indexOf(node._qsUuid) == -1) {
            evaluatedNodes = evaluatedNodes.concat(node._qsUuid);
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

        // Data type is uuids of Action (i.e., string).
        var nodeConditions = node?.entryCondition?.conditions ?? [];
        var nodeEntryConditionRes = true;
        node._unMetConditions = [];
        nodeConditions.forEach(nodeCondition => {
            if (!activatedActions.includes(nodeCondition)) {
                nodeEntryConditionRes = false
                var action = findActionById(nodeCondition);
                if (action.length > 0 && !node._unMetConditions.includes(action))
                    node._unMetConditions.push(action)
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

    //! Returns the action with the asked ID
    function findActionById(id: string) : string {
        for (var nodeKey in nodes) {
            var node = nodes[nodeKey];
            for (var actionKey in node?.nodeData?.data) {
                if (actionKey === id) {
                    return node.nodeData.data[actionKey].name + ", Node Name: " + node.title;
                }
            }
        }
        return ""; // Action not found
    }

    // update activate actions
    function updateActivatedActions() {
        var nodeActions = Object.values(node?.nodeData?.data ?? ({}));

        nodeActions.forEach(action => {
            // if the action is active and not included then add it
            if (action.active && !activatedActions.includes(action._qsUuid)) {
                activatedActions = activatedActions.concat(action._qsUuid);
            }
                // else if action is not active but is already included, then it should be deleted
                else if (!action.active && activatedActions.includes(action._qsUuid)) {
                    var removeActionIndex = activatedActions.indexOf(action._qsUuid);
                    activatedActions.splice(removeActionIndex, 1);
            }
        });

        // Use in future
        activatedActionsChanged();
    }

    //! Find the upstream node to select instead of selected node.
    function findNodeToSelect(node: Node) : Node {
        var nodeToSelect = node;
        if (!checkNodeEntryCondition(nodeToSelect)) {
            postLog("\r\n Can not select the last node.\r\n ");
            var upstreamNodeToSelect = previousNodes[nodeToSelect._qsUuid];
            if (upstreamNodeToSelect.length !==0) {
                nodeToSelect = nodes.find(node => node._qsUuid === upstreamNodeToSelect);
            }

            if(!checkNodeEntryCondition(nodeToSelect)) {
                // Select root node
                postLog("\r\n Select the ROOT node.\r\n ");
                nodeToSelect = nodes.find(node => node.type === NLSpec.NodeType.Root);
                nodeToSelect?.updateNodeStatus(NotionNode.NodeStatus.Selected);
            }
        }

        return nodeToSelect;
    }
}
