import QtQuick
import QtQuick.Controls
import NodeLink
 import QtQml

/*! ***********************************************************************************************
 * The NodeUndoObserver update UndoStack when Nodes properties changed.
 * ************************************************************************************************/

Item {
    id: root
    property Node           node
    property UndoStack      stackFlow

    property Timer _timer : Timer {
        repeat: false
        interval: 50
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
            root._timer.start();
        }

        function onTypeChanged() {
            root._timer.start();
        }

        function onPortsChanged() {
            root._timer.start();
        }
    }

    GuiConfigUndoObserver {
      guiConfig: root.node.guiConfig
      stackFlow: root.stackFlow
    }
}
