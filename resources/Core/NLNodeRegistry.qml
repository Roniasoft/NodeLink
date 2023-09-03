pragma Singleton

import QtQuick
import QtQuick.Controls

import NodeLink

QtObject {

    /* Properties
     * ****************************************************************************************/
    //! Registre imports to create a node type
    property var imports: []

    //! Registre Node class names to create them into app.
    //! map <id: int, nodeType: string>
    property var nodeTypes: ({})

    //! Registre Node names to show
    //! map <id: int, nodeName: string>
    property var nodeNames: ({})

    //! Registre Node icons to show
    //! map <id: int, nodeIcon: string>
    property var nodeIcons: ({})

    //! Registre Node Colors to show
    //! map <id: int, nodeColor: string>
    property var nodeColors: ({})

    //! Set a node type to create it in defaul modes
    property int defaultNode: 0

}
