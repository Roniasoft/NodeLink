import QtQuick
import QtQuickStream

import NodeLink
import VisionLink

/*! ***********************************************************************************************
 * BlurOperationNode applies blur effect to an image
 * ************************************************************************************************/
OperationNode {

    /* Object Properties
     * ****************************************************************************************/
    operationType: CSpecs.OperationType.Blur
    type: CSpecs.NodeType.Blur

    /* Property Declarations
     * ****************************************************************************************/
    property real blurRadius: 5.0  // 0.0 to 20.0

    /* Functions
     * ****************************************************************************************/
    //! Update node data with the BLUR process
    function updataData() {
        if (!nodeData.input) {
            nodeData.data = null;
            return;
        }
        // Check if input is a file path or image data
        var inputImage;
        if (typeof nodeData.input === "string") {
            // It's a file path, load it
            inputImage = ImageProcessor.loadImage(nodeData.input);
        } else {
            // It's already image data
            inputImage = nodeData.input;
        }

        // Validate image
        if (!ImageProcessor.isValidImage(inputImage)) {
            nodeData.data = null;
            return;
        }

        // Apply blur
        var blurredImage = ImageProcessor.applyBlur(inputImage, blurRadius);
        
        if (!ImageProcessor.isValidImage(blurredImage)) {
            nodeData.data = null;
            return;
        }

        // Store the processed image
        nodeData.data = blurredImage;
    }
}
