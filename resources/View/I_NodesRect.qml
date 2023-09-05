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

    //! Default Link and Node views
    property string nodeViewUrl: "NodeView.qml"
    property string linkViewUrl: "LinkView.qml"


    //! NodeView map as an internal map
    property var _nodeViewMap: ({})

    //! LinkView map as an internal map
    property var _linkViewMap: ({})


    //! Node view component
    property Component nodeViewComponent: Qt.createComponent(nodeViewUrl);

    //! Link view component
    property Component linkViewComponent: Qt.createComponent(linkViewUrl);

    /*  Object Properties
    * ****************************************************************************************/
    anchors.fill: parent

    Keys.forwardTo: parent

    /*  Children
    * ****************************************************************************************/

    //! Connection to manage node model changes.
    Connections {
        target: scene

        //! nodeRepeater updated when a node added
        function onNodeAdded(nodeObj: Node) {
            const objView = nodeViewComponent.createObject(parent, {
                                                           scene: root.scene,
                                                           sceneSession: root.sceneSession,
                                                           node: nodeObj,
                                                           viewProperties: root.viewProperties
                                                       });
            _nodeViewMap[nodeObj._qsUuid] = objView;
        }

        //! nodeRepeater updated when a node Removed
        function onNodeRemoved(nodeObj: Node) {
            if (!Object.keys(_nodeViewMap).includes(nodeObj._qsUuid))
                return;

            // Destroy object
            let nodeViewObj = _nodeViewMap[nodeObj._qsUuid];
            nodeViewObj.destroy();

            // Delete from map
            delete _nodeViewMap[nodeObj._qsUuid];
        }

        //! linkRepeater updated when a link added
        function onLinkAdded(linkObj: Link) {
            const objView = linkViewComponent.createObject(parent, {
                                                                 link: linkObj,
                                                                 scene: root.scene,
                                                                 sceneSession: root.sceneSession,
                                                                 viewProperties: root.viewProperties
                                                             });
            // Object is ready immediately
            _linkViewMap[linkObj._qsUuid] = objView;
        }

        //! linkRepeater updated when a link Removed
        function onLinkRemoved(linkObj: Link) {
            if (!Object.keys(_linkViewMap).includes(linkObj._qsUuid))
                return;

            // Destroy object
            let nodeViewObj = _linkViewMap[linkObj._qsUuid];
            nodeViewObj.destroy();

            // Delete from map
            delete _linkViewMap[linkObj._qsUuid];
        }
    }
}
