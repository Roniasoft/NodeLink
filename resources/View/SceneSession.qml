import QtQuick

/*! ***********************************************************************************************
 *
 * ************************************************************************************************/
QtObject {

    //! Connection View
//    property ConnectionView tempConnection: ConnectionView {}

    property point tempConnectionStartPos: Qt.point(0,0)

    property point tempConnectionEndPos: Qt.point(100,100)

    property bool   creatingConnection: false
}
