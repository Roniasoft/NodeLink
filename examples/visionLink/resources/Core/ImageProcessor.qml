pragma Singleton

import QtQuick
import VisionLink

/*! ***********************************************************************************************
 * The ImageProcessor is a wrapper singleton that provides access to ImageProcessorCPP.
 * ************************************************************************************************/
QtObject {
    // Expose ImageProcessorCPP singleton methods
    
    function loadImage(path) {
        return ImageProcessorCPP.loadImage(path);
    }
    
    function applyBlur(imageData, radius) {
        return ImageProcessorCPP.applyBlur(imageData, radius);
    }
    
    function applyBrightness(imageData, level) {
        return ImageProcessorCPP.applyBrightness(imageData, level);
    }
    
    function applyContrast(imageData, level) {
        return ImageProcessorCPP.applyContrast(imageData, level);
    }
    
    function saveToDataUrl(imageData) {
        return ImageProcessorCPP.saveToDataUrl(imageData);
    }
    
    function isValidImage(imageData) {
        return ImageProcessorCPP.isValidImage(imageData);
    }
}

