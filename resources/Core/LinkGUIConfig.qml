import QtQuick
import QtQuickStream

/*! ***********************************************************************************************
 * The LinkGuiConfig is a QSObject that keep the Ui Link properties.
 * ************************************************************************************************/
QSObject {

    /* Property Properties
     * ****************************************************************************************/

    //! Link description
    property string     description : ""

    //! Color
    property string     color:      "white"

    //! Color
    property int         style:      NLSpec.LinkStyle.Solid

}
