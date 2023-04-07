import QtQuick
import NodeLink

/*! ***********************************************************************************************
 * The UndoLinkObserver update UndoStack when Link properties changed.
 * ************************************************************************************************/

Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    property Link       link

    property UndoStack  undoStack

    property Timer _timer : Timer {
        repeat: false
        interval: 50
        onTriggered: {
            undoStack.updateStacks();
        }
    }

    /* Childeren
     * ****************************************************************************************/

    Connections {
        target: link

        function onDirectionChanged() {
            root._timer.start();
        }

        function onLinkTypeChanged() {
            root._timer.start();
        }
    }

    Connections {
        target: link.guiConfig

        function onDescriptionChanged() {
            root._timer.start();
        }

        function onColorChanged() {
            root._timer.start();
        }
    }
}
