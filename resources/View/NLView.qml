import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import NodeLink
import QtQuickStream

Item {
    id: view

    /* Property Declarations
    * ****************************************************************************************/
    property Scene          scene

    property SceneSession   sceneSession:   SceneSession {}

    //! Nodes Scene (flickable)
    property Component      nodesScene: NodesScene {
        scene: view.scene
        sceneSession: view.sceneSession
    }

    /* Children
    * ****************************************************************************************/
    //! Loader Nodes Scene (flickable)
    Loader {
        id: nodesSceneLoader
        anchors.fill: parent
        sourceComponent: nodesScene
    }

    //! Overview Rect
    NodesOverview {
        id: overView

        scene: view.scene
        sceneSession: view.sceneSession
        overviewWidth: NLStyle.overview.width
        overviewHeight: NLStyle.overview.height

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        clip: true
    }

    //! Side Menu
    SideMenu {
        scene: view.scene
        sceneSession: view.sceneSession
        anchors.right: parent.right
        anchors.rightMargin: 45
        anchors.top: parent.top
        anchors.topMargin: 50
    }

    //! Connection to set zoom after undo
    Connections {
        target: scene?.sceneGuiConfig ?? null

        function onZoomFactorChanged () {
            if (sceneSession.zoomManager.zoomFactor !== scene.sceneGuiConfig.zoomFactor)
                sceneSession.zoomManager.customZoom(scene.sceneGuiConfig.zoomFactor)
        }
    }

    //! Connection to set sceneGuiConfig to the user requested zoomFactor
    Connections {
        target: sceneSession?.zoomManager ?? null

        function onZoomFactorChanged () {
            scene.sceneGuiConfig.zoomFactor = sceneSession.zoomManager.zoomFactor

        }
    }

    //! Connection to handle copy and paste
    Connections {
        target: scene
        function onCopyCalled() {
            copyNodes();
        }
        function onPasteCalled() {
            pasteNodes();
        }
    }

    //! Zoom needs to be set the first time scene is loaded
    Component.onCompleted: {
        if (scene && scene._qsRepo._isLoading)
            sceneSession.zoomManager.customZoom(scene.sceneGuiConfig.zoomFactor)
        else if (scene && sceneSession)
            scene.sceneGuiConfig.zoomFactor = sceneSession.zoomManager.zoomFactor
    }

    /* Functions
    * ****************************************************************************************/
    //! Copying selected Nodes
    function copyNodes() {
        NLCore._copiedNodes = ({})
        NLCore._copiedLinks = ({})
        NLCore._copiedContainers = ({})

        var selectedNodes = Object.values(scene.selectionModel?.selectedModel ?? ({})).filter(obj => obj?.objectType === NLSpec.ObjectType.Node)
        var selectedLinks = Object.values(scene.selectionModel?.selectedModel ?? ({})).filter(obj => obj?.objectType === NLSpec.ObjectType.Link)
        var selectedContainers = Object.values(scene.selectionModel?.selectedModel ?? ({})).filter(obj => obj?.objectType === NLSpec.ObjectType.Container)

        selectedNodes.forEach(node => {NLCore._copiedNodes[node._qsUuid] = node;});
        selectedLinks.forEach(link => {NLCore._copiedLinks[link._qsUuid] = link;});
        selectedContainers.forEach(container => {NLCore._copiedContainers[container._qsUuid] = container;});

        NLCore._copiedNodesChanged();
        NLCore._copiedLinksChanged();
        NLCore._copiedContainersChanged();
    }

    //! Function to paste nodes. Currently only works for nodes and not links
    function pasteNodes() {
        var copiedNodes = ({});

        var minX = Number.POSITIVE_INFINITY
        var minY = Number.POSITIVE_INFINITY
        var maxX = Number.NEGATIVE_INFINITY
        var maxY = Number.NEGATIVE_INFINITY

        var allObjects = [...Object.values(NLCore._copiedNodes), ...Object.values(NLCore._copiedContainers)];

        //! Finding topleft and bottom right of the copied node rectangle
        allObjects.forEach(node1 => {
            minX = Math.min(minX, node1.guiConfig.position.x)
            maxX = Math.max(maxX, node1.guiConfig.position.x + node1.guiConfig.width)
            // Check y position
            minY = Math.min(minY, node1.guiConfig.position.y)
            maxY = Math.max(maxY, node1.guiConfig.position.y + node1.guiConfig.height)
        });

        //! Top Left of the nodes rectangle that will be pasted
        var topLeftX = scene.sceneGuiConfig.contentX * (1 / sceneSession.zoomManager.zoomFactor) +
            (scene.sceneGuiConfig.sceneViewWidth * (1 / sceneSession.zoomManager.zoomFactor))  / 2 - (maxX - minX) / 2
        var topLeftY = scene.sceneGuiConfig.contentY * (1 / sceneSession.zoomManager.zoomFactor) +
            (scene.sceneGuiConfig.sceneViewHeight * (1 / sceneSession.zoomManager.zoomFactor)) / 2 - (maxY - minY) / 2

        //! Mapping previous copied rect to paste the new one
        var diffX = topLeftX - minX;
        var diffY = topLeftY - minY;

        //! Handling exception: if mapped bottom right is too big for flickable
        if (maxX + diffX >= scene.sceneGuiConfig.contentWidth) {
            var tempXDiff = maxX + diffX - scene.sceneGuiConfig.contentWidth
            topLeftX -= tempXDiff
            diffX = topLeftX - minX
        }

        if (maxX + diffY >= scene.sceneGuiConfig.contentHeight) {
            var tempYDiff = maxY + diffY - scene.sceneGuiConfig.contentHeight
            topLeftY -= tempYDiff
            diffY = topLeftY - minY
        }

        //! Making a map of ports, copied node port to pasted node port
        var allPorts =  ({});
        var keys1;
        var keys2;

        //! Calling function to create desired Nodes, and mapping ports
        Object.values(NLCore._copiedNodes).forEach( node => {

            var copiedNode = createCopyNode(node, diffX, diffY)
            keys1 = Object.keys(node.ports);
            keys2 = Object.keys(copiedNode.ports);
            for (var i = 0; i < keys1.length; ++i) {
                var id1 = keys1[i];
                var id2 = keys2[i]
                var port1Value = node.ports[id1];
                var port2Value = copiedNode.ports[id2];

                allPorts[port1Value] = port2Value;
            }
            copiedNodes[copiedNode._qsUuid] = copiedNode;
        })
        //! Calling function to create Containers
        var copiedContainers = createCopiedContainers(diffX, diffY);
        //! Calling function to create links
        createCopiedLinks(allPorts);

        scene?.selectionModel.selectAll(copiedNodes, ({}), copiedContainers);
    }

    //! Creating coped nodes
    function createCopyNode(baseNode, diffX, diffY) {
        var node = QSSerializer.createQSObject(scene.nodeRegistry.nodeTypes[baseNode.type],
                                                       scene.nodeRegistry.imports, NLCore.defaultRepo);
        node._qsRepo = scene._qsRepo;
        node.cloneFrom(baseNode);

        // Fixing node position.
        node.guiConfig.position.x += diffX;
        node.guiConfig.position.y += diffY;
        // Add node into nodes array to updata ui
        scene.addNode(node);

        return node;
    }

    //! Creating copied containers
    function createCopiedContainers(diffX, diffY) {
        var copiedContainers = ({});

        Object.values(NLCore._copiedContainers).forEach(container => {
            var newContainer = scene.createContainer();
            newContainer.cloneFrom(container);

            newContainer.guiConfig.position.x += diffX;
            newContainer.guiConfig.position.y += diffY;

            scene.addContainer(newContainer);
            copiedContainers[newContainer._qsUuid] = newContainer;

        })

        return copiedContainers;
    }

    //! Creating coped links
    function createCopiedLinks(allPorts) {
        Object.values(NLCore._copiedLinks).forEach( link => {
            var matchedInputPort;
            var matchedOutputPort;
            Object.keys(allPorts).forEach(port => {
                if(String(link.inputPort) === String(port))
                    matchedInputPort = allPorts[port];

                if(String(link.outputPort) === String(port))
                    matchedOutputPort = allPorts[port];
            })
            var copiedLink = scene.createLink(matchedInputPort._qsUuid, matchedOutputPort._qsUuid)
            copiedLink._qsRepo = scene._qsRepo;
            copiedLink.cloneFrom(link);
        })
    }

}
