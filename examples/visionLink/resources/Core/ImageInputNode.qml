import QtQuick
import QtQuickStream
import QtQuick.Dialogs
import QtQuick.Controls

import NodeLink

/*! ***********************************************************************************************
 * ImageInputNode loads and provides image data to the processing pipeline
 * ************************************************************************************************/
Node {

    /* Object Properties
     * ****************************************************************************************/
    type: CSpecs.NodeType.ImageInput
    nodeData: I_NodeData {}

    guiConfig.width: 250
    guiConfig.height: 220

    /* Property Declarations
     * ****************************************************************************************/
    property string imagePath: ""

    /* Children
    * ****************************************************************************************/
    Component.onCompleted: addPorts();

    //! Override function
    //! Handle clone node operation
    //! Empty the nodeData.data
    onCloneFrom: function (baseNode)  {
        nodeData.data = null;
        imagePath = "";
    }

    /* Functions
     * ****************************************************************************************/
    //! Create ports for operation nodes
    function addPorts () {
        let _port1 = NLCore.createPort();

        _port1.portType = NLSpec.PortType.Output
        _port1.portSide = NLSpec.PortPositionSide.Right

        addPort(_port1);
    }

    //! Load and set image data
    function loadImage(path) {
        imagePath = path;
        
        // Load image using ImageProcessor
        var loadedImage = ImageProcessor.loadImage(path);
        
        if (ImageProcessor.isValidImage(loadedImage)) {
            nodeData.data = loadedImage;
        } else {
            nodeData.data = null;
        }
    }
}
