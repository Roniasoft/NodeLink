import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * The NodeDataLogger update StackFlowCore when Nodes properties changed.
 * ************************************************************************************************/

Item {
    property var           nodes
    property StackFlowCore stackFlow

    /* Childeren
     * ****************************************************************************************/

    //! Node Loggers
    Repeater {
        model: Object.values(nodes)
        delegate: Item {
            Connections {
                target: modelData

                enabled: !NLCore.blockStackFlowConnection

                property Timer _timer : Timer {
                    repeat: true
                    interval: 250
                    onTriggered: {
                        stackFlow.updateStackFlow();
                        stop();
                    }
                }

                function onTitleChanged() {
                    stackFlow.updateStackFlow();
                }

                function onTypeChanged() {
                    stackFlow.updateStackFlow();
                }

                function onPortsChanged() {
                    stackFlow.updateStackFlow();
                }

                function onGuiConfigChanged() {
                    _timer.start();
                }
            }
        }
    }
}
