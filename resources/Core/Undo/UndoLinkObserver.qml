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

    //! Timer to damp excessive property change calls
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
    }

    Connections {
        target: link?.guiConfig ?? null

        function onDescriptionChanged() {
            root._timer.start();
        }

        function onColorChanged() {
            root._timer.start();
        }

        function onStyleChanged() {
            root._timer.start();
        }

        function onTypeChanged() {
            root._timer.start();
        }
    }
}
