import QtQuick
import QtQuickStream

/*! ***********************************************************************************************
 * The LinkGuiConfig is a QSObject that keep the Ui Link properties.
 * ************************************************************************************************/
QSObject {

    /* Property Properties
     * ****************************************************************************************/

    //! Link description
    property string description: ""

    //! Color
    property string color:       "white"

    property int colorIndex:     -1

    //! Style
    property int    style:       NLSpec.LinkStyle.Solid

    //! Type
    property int    type:        NLSpec.LinkType.Bezier

    //! isEditableDescription to handle editable description
    property bool _isEditableDescription: false

}
