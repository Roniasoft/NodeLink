import QtQuick
import QtQuick.Controls
import SituationSimulator
import NodeLink

/*! ***********************************************************************************************
 * SceneSimulation simulate nodes in scene.
 * ************************************************************************************************/

QtObject {

    /* Property Declarations
     * ****************************************************************************************/

    //! Log of simulation
    property var simulationLog: []

    //! Nodes Simulated
    property var simulatedNodes: []

    //! Scene model, use to simulation
    property Scene scene

    //! Start node
    property Node startNode

    //! All nodes in selected Scene
    //! use nodes map in Scene model
    property var nodes: Object.values(scene?.nodes)

    property var links: Object.values(scene?.links)


    /* Functions
     * ****************************************************************************************/

    //! Start simulation process
    function startSimulation() {
        // initialize new simulation in log
        updateSimulationLog("\nSimulation started ...;\n");

        // Find start node (Use root node as nodeStart)
        startNode = nodes.find(node => node.type === NLSpec.NodeType.Root);
        if (!startNode) {
            updateSimulationLog("Simulation failed !!!");
            return false;
        }

        //! update simulation log with strat node
        updateSimulationLog("Simulation start from " + startNode.title)

        simulation(startNode);

        updateSimulationLog("\nSimulation finished. \n")
    }

    //! Simulation method
    function simulation(node : Node) {
        var simulationNodes  = nodeSimulation(node);

        simulationNodes.forEach(nodeObj => simulation(nodeObj));
    }

    //! Node simulation
    function nodeSimulation(node : Node) {
        // Update log
        updateSimulationLog(node.title + " was selected.");

        // Filter links that inputPort is node
        // List<Link>
        var simulationNodeLinks = links.filter(link => scene.findNodeId(link.inputPort._qsUuid) === node._qsUuid);

        // Filter all nodes that inputPort is node and connected with simulationNodeLinks
        // List<Node>
        var downstreamNodes = []
        simulationNodeLinks.forEach(link => {

                                        var nodeUuid = scene.findNodeId(link.outputPort._qsUuid);
                                        var simulatioNode_t = scene.nodes[nodeUuid];

                                        // When node is transient, the node data must be used instead original node.
                                        if(simulatioNode_t?.type === NLSpec.NodeType.Transition) {
                                            var transientTo = scene.findNodeId(simulatioNode_t?.nodeData?.data)

                                            simulatioNode_t = transientTo;
                                        }

                                        // Data type is Action.
                                        var nodeData = Object.values(simulatioNode_t?.entryCondition?.conditions ?? ({}));
                                        var notActiveData = nodeData.filter(data => !data.isActive)

                                        // Indicates the reason why the node was ignored
                                        if(notActiveData.length > 0) {
                                            updateSimulationLog(simulatioNode_t.title + " ignored")
                                            notActiveData.forEach(data => {
                                                                      updateSimulationLog(data.name + " is not active.");
                                                                  });
                                        } else if(simulatioNode_t !== undefined) {
                                            // Push node for simulations.
                                            downstreamNodes.push(simulatioNode_t);
                                        }
                                    });

        // Update log
        updateSimulationLog(node.title + " was simulated.");

        return downstreamNodes;

    }

    //! reset simulation
    function resetSimulation() {

    }

    //! Update simulation log
    function updateSimulationLog(log : string) {
        console.log("Simulation :" + log)
        simulationLog.push(log);
    }
}
