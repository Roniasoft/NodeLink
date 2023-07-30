pragma Singleton

import QtQuick

/*! ***********************************************************************************************
 *
 * \todo Decide if all colors are necasary or if some can be merged
 * ************************************************************************************************/
QtObject {

    /* Property Declarations
     * ****************************************************************************************/
    property alias radiusAmount: _radiusAmount
    property alias fontType:     _fontType

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
        //! The current OverView is corrupted, must be updated based on plan.
        property bool visible:        false
    }

    //! Defualt Scene contents dimension.
    readonly property QtObject scene: QtObject {
        property real defaultContentWidth:  4000
        property real defaultContentHeight: 4000
        property real defaultContentX:      1500
        property real defaultContentY:      1500
    }

    //! Defualt Node parameters.
    readonly property QtObject node: QtObject {
        property real   width:  200
        property real   height: 150
        property string color:  "pink"
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

    //! Style icon of links
    readonly property var linkStyleIcon: [
        "\uf111",       // Solid
        "\uf1ce",       // Dash
        "\ue105"        // Dot
    ]

    //! Style icon of links
    readonly property var linkTypeIcon: [
        "\uf899",       // Bezier
        "L",            // LLine
        "/"             // Straight
    ]

    readonly property var nodeNames: [
        "GeneralNode",          // General
        "RootNode",             // Root
        "StepNode",             // Step
        "TransitionNode",       // Transition
        "MacroNode"             // Macro
    ]

    //! Node type string list to show nodeTypes text.
    readonly property var objectTypesString: [
        "General",          // General
        "Root",             // Root
        "Step",             // Step
        "Transition",       // Transition
        "Macro",            // Macro
        "Link",             // Link

        "Unknown"             // Unknown
    ]

    //! Radius
    readonly property QtObject _radiusAmount: QtObject {
        id: _radiusAmount

        readonly property double nodeOverview:   20
        readonly property double blockerNode:    10
        readonly property double confirmPopup:   10
        readonly property double nodeView:       10
        readonly property double linkView:       5
        readonly property double itemButton:     5
        readonly property double toolTip:        4
    }

    //! Font
    readonly property QtObject _fontType: QtObject {
        id: _fontType

        readonly property string roboto:   "Roboto"
        readonly property string font6Pro: "Font Awesome 6 Pro"
    }
}
