import QtQuick
import QtQuickStream

import NodeLink

/*! ***********************************************************************************************
 * Manages Node Images
 * ************************************************************************************************/
QSObject {
    /* Property Declarations
    * ****************************************************************************************/
    property var imagesSources:   []

    //! Image source picture
    property int coverImageIndex: -1

    /* Functions
    * ****************************************************************************************/
    function addImage(base64int) {
        if (!base64int)
            return;
        imagesSources.push(base64int)
        imagesSourcesChanged();
    }

    function deleteImage(base64int) {
        var imageId = imagesSources.indexOf(base64int);
        imagesSources.splice(imageId, 1);
        imagesSourcesChanged();
    }
}
