import QtQuick
import QtQuickStream

import NodeLink
import VisionLink

/*! ***********************************************************************************************
 * ContrastOperationNode adjusts contrast of an image
 * ************************************************************************************************/
OperationNode {

    /* Object Properties
     * ****************************************************************************************/
    operationType: CSpecs.OperationType.Contrast
    type: CSpecs.NodeType.Contrast

    /* Property Declarations
     * ****************************************************************************************/
    property real contrastLevel: 0.0  // -1.0 to 1.0 (0 = normal)

    /* Functions
     * ****************************************************************************************/
    //! Update node data with the CONTRAST process
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

        // Apply contrast
        var processedImage = ImageProcessor.applyContrast(inputImage, contrastLevel);
        
        if (!ImageProcessor.isValidImage(processedImage)) {
            nodeData.data = null;
            return;
        }

        // Store the processed image
        nodeData.data = processedImage;
    }
}
