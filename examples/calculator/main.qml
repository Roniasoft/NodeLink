import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls

import QtQuickStream
import NodeLink
import Calculator

/*! ***********************************************************************************************
 * MainWindow of calculator example
 * ************************************************************************************************/

Window {
    id: window

    /* Property Declarations
     * ****************************************************************************************/

    //! Scene
    property CalculatorScene scene: null

    /* Object Properties
     * ****************************************************************************************/

    width: 1280
    height: 960
    visible: true
    title: qsTr("Calculator Example")
    color: "#1e1e1e"

    Material.theme: Material.Dark
    Material.accent: "#4890e2"


    Component.onCompleted: {
        // Registre nodes in NodeLink
        NLNodeRegistry.imports = ["Calculator"]

        NLNodeRegistry.defaultNode = CSpecs.NodeType.Source
        NLNodeRegistry.nodeTypes = [
                    CSpecs.NodeType.Source      = "SourceNode",
                    CSpecs.NodeType.Additive    = "AdditiveNode",
                    CSpecs.NodeType.Multiplier  = "MultiplierNode",
                    CSpecs.NodeType.Subtraction = "SubtractionNode",
                    CSpecs.NodeType.Division    = "DivisionNode",
                    CSpecs.NodeType.Result      = "ResultNode"
                ];

        NLNodeRegistry.nodeNames = [
                    CSpecs.NodeType.Source      = "Source",
                    CSpecs.NodeType.Additive    = "Additive",
                    CSpecs.NodeType.Multiplier  = "Multiplier",
                    CSpecs.NodeType.Subtraction = "Subtraction",
                    CSpecs.NodeType.Division    = "Division",
                    CSpecs.NodeType.Result      = "Result"
                ];

        NLNodeRegistry.nodeIcons = [
                    CSpecs.NodeType.Source      = "\ue4e2",
                    CSpecs.NodeType.Additive    = "+",
                    CSpecs.NodeType.Multiplier  = "\uf00d",
                    CSpecs.NodeType.Subtraction = "-",
                    CSpecs.NodeType.Division    = "/",
                    CSpecs.NodeType.Result      = "\uf11b",
                ];

        NLNodeRegistry.nodeColors = [
                    CSpecs.NodeType.Source     = "#444",
                    CSpecs.NodeType.Additive    = "#444",
                    CSpecs.NodeType.Multiplier  = "#444",
                    CSpecs.NodeType.Subtraction = "#444",
                    CSpecs.NodeType.Division    = "#444",
                    CSpecs.NodeType.Result      = "#444",
                ];

        // Create root object
        NLCore.defaultRepo = NLCore.createDefaultRepo(["QtQuickStream", "Calculator"])
        NLCore.defaultRepo.initRootObject("CalculatorScene");
        window.scene = Qt.binding(function() { return NLCore.defaultRepo.qsRootObject;});
    }

    /* Fonts
     * ****************************************************************************************/
    FontLoader { source: "qrc:/Calculator/resources/fonts/Font Awesome 6 Pro-Thin-100.otf" }
    FontLoader { source: "qrc:/Calculator/resources/fonts/Font Awesome 6 Pro-Solid-900.otf" }
    FontLoader { source: "qrc:/Calculator/resources/fonts/Font Awesome 6 Pro-Regular-400.otf" }
    FontLoader { source: "qrc:/Calculator/resources/fonts/Font Awesome 6 Pro-Light-300.otf" }


    /* Children
     * ****************************************************************************************/

    //! CalculatorView
    CalculatorView {
        id: view
        scene: window.scene
        anchors.fill: parent
    }
}
