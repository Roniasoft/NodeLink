import QtQuick
import QtQuick.Controls
import QtQml
import NodeLink

/*! ***********************************************************************************************
 * The GuiConfigUndoObserver observe NodeGuiConfig properties changes.
 * ************************************************************************************************/
Item {
    id: root

    /* Property Properties
     * ****************************************************************************************/
    property NodeGuiConfig  guiConfig

    property UndoStack      undoStack

    property Timer _timer : Timer {
        repeat: false
        interval: 300
        onTriggered: {
            undoStack.updateStacks();
        }
    }

    /* Childeren
     * ****************************************************************************************/

    Connections {
        target: guiConfig

        enabled: !NLSpec.undo.blockObservers

        function onNameChanged() {
            _timer.start();
        }

        function onLogoUrlChanged() {
            _timer.start();
        }

        function onPositionChanged() {
            _timer.start();
        }

        function onWidthChanged() {
            _timer.start();
        }

        function onHeightChanged() {
            _timer.start();
        }

        function onColorChanged() {
            _timer.start();
        }
    }
}
