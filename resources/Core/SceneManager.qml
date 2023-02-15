import QtQuick 2.15


/*! ***********************************************************************************************
 * The SceneManager is responsible for managing nodes and connections between them.
 *
 * ************************************************************************************************/
QtObject {
    id: sceneManager

    /* Property Properties
     * ****************************************************************************************/

    property var nodes: []
    property var connections: []

    property QtObject privateProperty: QtObject {
        property int currentConnection: -1
    }

    property Node _node1: Node {
        x: 0
        y: 0
        color: "#3b8a89"
    }
    property Node _node2: Node {
        x: 0
        y: 200
        color: "#3a9d57"
    }
    property Node _node3: Node {
        x: 150
        y: 25
        color: "#6e57b8"
    }
    property Node _node4: Node {
        x: 350
        y: 200
        color: "#fb464c"
    }

    Component.onCompleted: {
        nodes = nodes.concat(_node1, _node2, _node3, _node4);
    }

    /* Functions
     * ****************************************************************************************/
    function createConnection(inputPort : Port, outputPort : Port) {

        let obj = Qt.createQmlObject("import QtQuick;Connection {}", sceneManager);

        obj.inputPort    = inputPort;
        obj.outputPort   = outputPort;
        obj.connectionID = connections.length;
        privateProperty.currentConnection = obj.connectionID;
        connections.push(obj);
        connectionsChanged();
        console.info("info ",connections.length)
    }

    function updateConnection(inputPort : Port, outputPort : port) {

        var objs = connections.find((obj) =>
                   obj.connectionID === privateProperty.currentConnection);

        var conObj = objs;
        conObj.inputPort    = inputPort;
        conObj.outputPort   = outputPort;

        var index = connections.indexOf(objs);
        connections.splice(index, 1);

        connections.push(conObj);
        console.info("info 2 =",connections.length)

        connectionsChanged();
    }

}
