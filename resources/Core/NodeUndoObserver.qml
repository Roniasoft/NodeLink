import QtQuick
import QtQuick.Controls
import NodeLink

/*! ***********************************************************************************************
 * The NodeUndoObserver update UndoStack when Nodes properties changed.
 * ************************************************************************************************/

Item {
    id: root
    property Node           node: null
    property UndoStack      stackFlow

    property Timer _timer : Timer {
        repeat: false
        interval: 250
        onTriggered: {
            stackFlow.updateStackFlow();
        }
    }

    /* Childeren
     * ****************************************************************************************/

    Connections {
        target: node

        enabled: !NLSpec.undoProperty.blockUndoStackConnection

        function onTitleChanged() {
            _timer.start();
        }

        function onTypeChanged() {
            _timer.start();
        }

        function onPortsChanged() {
            _timer.start();
        }

        function onGuiConfigChanged() {
            _timer.start();
        }
    }
}
