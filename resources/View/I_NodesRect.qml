import QtQuick
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * I_NodesRect is an interface classs that shows nodes.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Declarations
    * ****************************************************************************************/
    property I_Scene      scene

    property SceneSession sceneSession

    //! viewProperties encompasses all view properties that are not included in either the scene or the scene session.
    property QtObject viewProperties: null

    //! Default Link and Node and Container views
    property string nodeViewUrl: scene?.nodeRegistry?.nodeView ?? ""
    property string linkViewUrl: scene?.nodeRegistry?.linkView ?? ""
    property string containerViewUrl: scene?.nodeRegistry?.containerView ?? ""


    //! NodeView map as an internal map
    property var _nodeViewMap: ({})

    //! LinkView map as an internal map
    property var _linkViewMap: ({})

    //! LinkView map as an internal map
    property var _containerViewMap: ({})

    //! Node view component
    property Component nodeViewComponent: Qt.createComponent(nodeViewUrl);

    //! Link view component
    property Component linkViewComponent: Qt.createComponent(linkViewUrl);

    //! Container view component
    property Component containerViewComponent: Qt.createComponent(containerViewUrl);

    /*  Object Properties
    * ****************************************************************************************/
    anchors.fill: parent

    z: 3

    Keys.forwardTo: parent

    /*  Children
    * ****************************************************************************************/

    //! Connection to manage node model changes.
    Connections {
        target: scene

        //! containerRepeater updated when a container added
        function onContainerAdded(containerObj: Container) {
            if (Object.keys(_containerViewMap).includes(containerObj._qsUuid))
                return;

            //! NodeViews should be child of NodesRect so they also get the zoom factor through
            //! scaling
            const objView = containerViewComponent.createObject(root, {
                                                           scene: root.scene,
                                                           sceneSession: root.sceneSession,
                                                           container: containerObj,
                                                           viewProperties: root.viewProperties
                                                       });
            _containerViewMap[containerObj._qsUuid] = objView;
        }

        //! nodeRepeater updated when containers Removed
        function onContainersRemoved(containerArray: list<Container>) {
            for (var i = 0; i < containerArray.length; i++) {
                var containerObj = containerArray[i];
                var containerObjId = containerObj._qsUuid;
                containerObj.destroy()
                if (_containerViewMap[containerObjId]) {
                    _containerViewMap[containerObjId].destroy()
                    delete _containerViewMap[containerObjId];
                }
            }
        }

        //! nodeRepeater updated when a container Removed
        function onContainerRemoved(containerObj: Container) {
            if (!Object.keys(_containerViewMap).includes(containerObj._qsUuid))
                return;

            let containerObjId = containerObj._qsUuid;

            let containerViewObj = _containerViewMap[containerObjId];
            if (containerViewObj) {
                containerViewObj.destroy();
            }

            delete _containerViewMap[containerObjId];
        }

        function onNodesAdded(nodeArray: list<Node>) {
            var jsArray = [];
            for (var i = 0; i < nodeArray.length; i++) {
                jsArray.push(nodeArray[i]);
            }
            var result = ObjectCreator.createItems(
                        "node",
                        jsArray,
                        root,
                        nodeViewComponent.url,
                        {
                            "scene": root.scene,
                            "sceneSession": root.sceneSession,
                            "viewProperties": root.viewProperties
                            // "node": will be added inside cpp class
                        }
                        );
            if (result.needsPropertySet) {
                for (var i = 0; i < result.items.length; i++) {
                    result.items[i].scene = root.scene;
                    result.items[i].sceneSession = root.sceneSession;
                    result.items[i].node = nodeArray[i];
                    result.items[i].viewProperties = root.viewProperties;
                }
            } else {
                for (var i = 0; i < result.items.length; i++) {
                    _nodeViewMap[nodeArray[i]._qsUuid] = result.items[i];
                }
            }
        }


        //! nodeRepeater updated when a node added
        function onNodeAdded(nodeObj: Node) {
            if (Object.keys(_nodeViewMap).includes(nodeObj._qsUuid))
                return;

            //! NodeViews should be child of NodesRect so they also get the zoom factor through
            //! scaling

            var result = ObjectCreator.createItem(
                    root,
                    nodeViewComponent.url,
                    {
                        "scene": root.scene,
                        "sceneSession": root.sceneSession,
                        "node": nodeObj,
                        "viewProperties": root.viewProperties
                    }
                    );

            if (result.needsPropertySet) {
                result.item.scene = root.scene;
                result.item.sceneSession = root.sceneSession;
                result.item.node = nodeObj;
                result.item.viewProperties = root.viewProperties;
            }

            _nodeViewMap[nodeObj._qsUuid] = result.item;
        }

        // ! nodeRepeater updated when several nodes Removed
        function onNodesRemoved(nodeArray: list<Node>) {
            for (var i = 0; i < nodeArray.length; i++) {
                var nodeObj = nodeArray[i];
                var nodeObjId = nodeObj._qsUuid;
                let nodePorts = nodeObj.ports
                Object.entries(nodePorts).forEach(
                            ([portId, port]) => {
                                nodeObj.deletePort(port)
                            });
                nodeObj.destroy()
                if (_nodeViewMap[nodeObjId]) {
                    _nodeViewMap[nodeObjId].destroy()
                    delete _nodeViewMap[nodeObjId];
                }
            }
        }

        //! nodeRepeater updated when a node Removed
        function onNodeRemoved(nodeObj: Node) {
            let nodeObjId = nodeObj._qsUuid;

            if (!_nodeViewMap[nodeObjId])
                return;

            let nodeViewObj = _nodeViewMap[nodeObjId];
            if (nodeViewObj) {
                nodeViewObj.destroy();
            }

            delete _nodeViewMap[nodeObjId];
        }

        //! linkRepeater updated when a link added
        function onLinkAdded(linkObj: Link) {
            if (Object.keys(_linkViewMap).includes(linkObj._qsUuid))
                return;
            var result = ObjectCreator.createItem(
                              root,
                              linkViewComponent.url,
                              {
                                  "link": linkObj,
                                  "scene": root.scene,
                                  "sceneSession": root.sceneSession,
                                  "viewProperties": root.viewProperties
                              }
                              );

            if (result.needsPropertySet) {
                result.item.scene = root.scene;
                result.item.sceneSession = root.sceneSession;
                result.item.link = linkObj;
                result.item.viewProperties = root.viewProperties;
            }
            _linkViewMap[linkObj._qsUuid] = result.item;
        }

        //! linkRepeater updated when a link added
        function onLinksAdded(linkArray: list<Link>) {
            var jsArray = [];
            for (var i = 0; i < linkArray.length; i++) {
                jsArray.push(linkArray[i]);
            }
            var result = ObjectCreator.createItems(
                        "link",
                        jsArray,
                        root,
                        linkViewComponent.url,
                        {
                            "scene": root.scene,
                            "sceneSession": root.sceneSession,
                            "viewProperties": root.viewProperties
                        }
                        );
            if (result.needsPropertySet) {
                for (var i = 0; i < result.items.length; i++) {
                    result.items[i].scene = root.scene;
                    result.items[i].sceneSession = root.sceneSession;
                    result.items[i].link = linkArray[i];
                    result.items[i].viewProperties = root.viewProperties;
                    _linkViewMap[linkArray[i]._qsUuid] = result.items[i];
                }
            } else {
                for (var i = 0; i < result.items.length; i++) {
                    _linkViewMap[linkArray[i]._qsUuid] = result.items[i];
                }
            }
        }

        //! linkRepeater updated when a link Removed
        function onLinkRemoved(linkObj: Link) {
            let linkObjId = linkObj._qsUuid;

            if (!Object.keys(_linkViewMap).includes(linkObjId))
                return;

            // Destroy view object
            let linkViewObj = _linkViewMap[linkObjId];
            if (linkViewObj) {
                linkViewObj.destroy();
            }

            // Delete from map
            delete _linkViewMap[linkObjId];
        }
    }
}
