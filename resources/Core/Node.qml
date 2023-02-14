import QtQuick 2.15

/*! ***********************************************************************************************
 * Node is a model that manage node properties..
 * ************************************************************************************************/
QtObject {
    id: root
    /* Property Declarations
     * ****************************************************************************************/
    property string name:   "<unknown>"

    property string title: "<Unknown>"

    property int x:         0

    property int y:         0

    property int width:     200

    property int height:    120

    property string color: "pink"

    property int type:      NLSpec.NodeType.General

    // Port list
    property var ports:     []

    property QtObject privateProperty: QtObject {
        // isLoadingPorts block the onPortsChanged during position calculation process.
        property bool isLoadingPorts: false
    }

    /* Functions
     * ****************************************************************************************/
    onPortsChanged: {

        if(privateProperty.isLoadingPorts)
            return;

        privateProperty.isLoadingPorts = true;
        ports = privateFuncions.calcPositionPorts();
        privateProperty.isLoadingPorts = false;
    }

    property QtObject privateFuncions: QtObject {

        //! Calulate position of each port on the node based on sides.
        function calcPositionPorts() {

            var calcPorts = [];

            // Filter ports based on sides.
            var topPorts    = ports.filter(privateFuncions.isPortTopSide);
            var bottonPorts = ports.filter(privateFuncions.isPortBottonSide);
            var leftPorts   = ports.filter(privateFuncions.isPortLeftSide);
            var rightPorts  = ports.filter(privateFuncions.isPortRightSide);

            // Divide available spaces between ports.
            var topPortInterval     = width  / (topPorts.length + 1);
            var bottonPortsInterval = width  / (bottonPorts.length + 1);
            var leftPortsInterval   = height / (leftPorts.length + 1);
            var rightPortsInterval  = height / (rightPorts.length + 1);

            var counter = 1;
            topPorts.forEach(port => {
                                port.x = topPortInterval * counter;
                                port.y -= 1
                                counter++;
                                calcPorts.push(port);
                          })

            counter = 1;
            bottonPorts.forEach(port => {
                                port.x = bottonPortsInterval * counter;
                                port.y = root.height - 5;
                                counter++;
                                calcPorts.push(port);
                             })

            counter = 1;
            leftPorts.forEach(port => {
                                port.x -= 1;
                                port.y = leftPortsInterval * counter;
                                counter++;
                                calcPorts.push(port);
                             })

            counter = 1;
            rightPorts.forEach(port => {
                                port.x = root.width - 5
                                port.y = rightPortsInterval * counter;
                                counter++;
                                calcPorts.push(port);
                             })

            return calcPorts;
        }

        //! check Top side port
        function isPortTopSide(port : Port) {
            if(port.portSide === NLSpec.PortPositionSide.Top)
                return true;
            return false;
        }

        //! check Botton side port
        function isPortBottonSide(port : Port) {
            if(port.portSide === NLSpec.PortPositionSide.Botton)
                return true;
            return false;
        }

        //! check Left side port
        function isPortLeftSide(port : Port) {
            if(port.portSide === NLSpec.PortPositionSide.Left)
                return true;
            return false;
        }

        //! check Right side port
        function isPortRightSide(port : Port) {
            if(port.portSide === NLSpec.PortPositionSide.Right)
                return true;
            return false;
        }
    }
}
