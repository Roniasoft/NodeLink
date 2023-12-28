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

        function onLogoUrlChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            _timer.start();
        }

        function onPositionChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            _timer.start();
        }

        function onWidthChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            _timer.start();
        }

        function onHeightChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            _timer.start();
        }

        function onColorChanged() {
            if (_timer.running) {
                _timer.stop()
            }
            _timer.start();
        }
    }
}
