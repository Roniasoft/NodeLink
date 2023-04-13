pragma Singleton

import QtQuick

/*! ***********************************************************************************************
 *
 * \todo Decide if all colors are necasary or if some can be merged
 * ************************************************************************************************/
QtObject {

    /* Property Declarations
     * ****************************************************************************************/

    /* Button related
     * ****************************************************************************************/

    /* Port
     * ****************************************************************************************/
    readonly property QtObject portView: QtObject {
        property int size:          18
        property int borderSize:    2
    }

    readonly property QtObject overview: QtObject {
        property real scale:          0.15
        property bool visible:        true
    }

    property bool snapEnabled: false

    readonly property var nodeIcons: [
        "\ue4e2",       // General
        "\uf04b",       // Root
        "\uf54b",       // Step
        "\ue57f",       // Transition
        "\uf2db"        // Macro
    ]

    readonly property var nodeColors: [
        "#444",       // General
        "#333",       // Root
        "#3D9798",    // Step
        "#625192",    // Transition
        "#9D9E57"     // Macro
    ]

    //! Direction icon of links
    readonly property var linkDirectionIcon: [
        "\ue404",       // Nondirectional
        "\ue4c1",       // Unidirectional
        "\uf07e"        // Bidirectional
    ]

    readonly property var nodeNames: [
        "GeneralNode",          // General
        "RootNode",             // Root
        "StepNode",             // Step
        "TransitionNode",       // Transition
        "MacroNode"             // Macro
    ]
}
