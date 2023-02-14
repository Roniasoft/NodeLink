import QtQuick

/*! ***********************************************************************************************
 * Connection is a model that manage connection properties..
 * ************************************************************************************************/

QtObject {

    // Connection ID
    property string name: "<unknown>"

    property int connectionID: 0

    // Input port
    property Port inputPort

    // Output port
    property Port outputPort
}
