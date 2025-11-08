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

    ObjectCreator { id: objectCreator }

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
            let createdViews = objectCreator.createItems(
                "node",
                jsArray,
                root,
                nodeViewUrl,
                {
                    "scene": root.scene,
                    "sceneSession": root.sceneSession,
                    "viewProperties": root.viewProperties
                    // "node": will be added inside cpp class
                }
            );
            for (var i = 0; i < createdViews.length; i++) {
                _nodeViewMap[nodeArray[i]._qsUuid] = createdViews[i];
            }
        }


        //! nodeRepeater updated when a node added
        function onNodeAdded(nodeObj: Node) {
            if (Object.keys(_nodeViewMap).includes(nodeObj._qsUuid))
                return;

            //! NodeViews should be child of NodesRect so they also get the zoom factor through
            //! scaling, url:"qrc:/NodeLink/resources/View/NodeView.qml"
            let nodeView = objectCreator.createItem(
                    root,
                    nodeViewUrl,
                    {
                        "scene": root.scene,
                        "sceneSession": root.sceneSession,
                        "node": nodeObj,
                        "viewProperties": root.viewProperties
                    }
                    );

            _nodeViewMap[nodeObj._qsUuid] = nodeView;
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

            const objView = objectCreator.createItem(
                              root,
                              linkViewUrl,
                              {
                                  "link": linkObj,
                                  "scene": root.scene,
                                  "sceneSession": root.sceneSession,
                                  "viewProperties": root.viewProperties
                              }
                              );
            _linkViewMap[linkObj._qsUuid] = objView;
        }

        //! linkRepeater updated when a link added
        function onLinksAdded(linkArray: list<Link>) {
            var jsArray = [];
                for (var i = 0; i < linkArray.length; i++) {
                    jsArray.push(linkArray[i]);
                }
            const createdLinks = objectCreator.createItems(
                              "link",
                              jsArray,
                              root,
                              linkViewUrl,
                              {
                                  "scene": root.scene,
                                  "sceneSession": root.sceneSession,
                                  "viewProperties": root.viewProperties
                              }
                              );
            for (var i = 0; i < createdLinks.length; i++) {
                _linkViewMap[linkArray[i]._qsUuid] = createdLinks[i];
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
