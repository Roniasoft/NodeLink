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
    property var undoSceneObserver

//    property Timer _timer : Timer {
//        repeat: false
//        interval: 300
//        onTriggered: {
//            undoStack.updateStacks();
//        }
//    }

    /* Childeren
     * ****************************************************************************************/

    Connections {
        target: guiConfig

        enabled: !NLSpec.undo.blockObservers

        function onLogoUrlChanged() {
//            if (_timer.running) {
//                _timer.stop()
//            }
//            _timer.start();
            undoSceneObserver.startTimer();
        }

        function onPositionChanged() {
//            undoSceneObserver.startTimer()
//            return;
//            if (_timer.running) {
//                _timer.stop()
//            }
//            _timer.start();
            undoSceneObserver.startTimer();
        }

        function onWidthChanged() {
//            if (_timer.running) {
//                _timer.stop()
//            }
//            _timer.start();
            undoSceneObserver.startTimer();
        }

        function onHeightChanged() {
//            if (_timer.running) {
//                _timer.stop()
//            }
//            _timer.start();
            undoSceneObserver.startTimer();
        }

        function onColorChanged() {
//            if (_timer.running) {
//                _timer.stop()
//            }
//            _timer.start();
            undoSceneObserver.startTimer();
        }
    }
}
