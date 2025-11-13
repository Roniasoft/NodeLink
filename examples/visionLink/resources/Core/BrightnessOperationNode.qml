import QtQuick
import QtQuickStream

import NodeLink
import VisionLink

/*! ***********************************************************************************************
 * BrightnessOperationNode adjusts brightness of an image
 * ************************************************************************************************/
OperationNode {

    /* Object Properties
     * ****************************************************************************************/
    operationType: CSpecs.OperationType.Brightness
    type: CSpecs.NodeType.Brightness

    /* Property Declarations
     * ****************************************************************************************/
    property real brightnessLevel: 0.0  // -1.0 to 1.0 (0 = normal)

    /* Functions
     * ****************************************************************************************/
    //! Update node data with the BRIGHTNESS process
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

        // Apply brightness
        var processedImage = ImageProcessor.applyBrightness(inputImage, brightnessLevel);
        
        if (!ImageProcessor.isValidImage(processedImage)) {
            nodeData.data = null;
            return;
        }

        // Store the processed image
        nodeData.data = processedImage;
    }
}
