pragma Singleton

import QtQuick

/*! ***********************************************************************************************
 *
 * \todo Decide if all colors are necasary or if some can be merged
 * ************************************************************************************************/
QtObject {

    /* Button related
     * ****************************************************************************************/

    /* Properties
     * ****************************************************************************************/
    readonly property string primaryColor:           "#4890e2"

    readonly property string primaryTextColor:       "white"

    readonly property string primaryBackgroundColor: "#1e1e1e"

    readonly property string primaryBorderColor:     "#363636"

    readonly property string backgroundGray:         "#2A2A2A"

    readonly property string primaryRed:             "#8b0000"

    readonly property QtObject portView: QtObject {
        property int size:          18
        property int borderSize:    2
    }

    readonly property QtObject overview: QtObject {
        property real width: 250
        property real height: 250
    }

    //! Defualt Scene contents dimension.
    readonly property QtObject scene: QtObject {
        property real maximumContentWidth:  12000
        property real maximumContentHeight: 12000
        property real defaultContentWidth:  4000
        property real defaultContentHeight: 4000
        property real defaultContentX:      1500
        property real defaultContentY:      1500
    }

    //! Defualt Node parameters.
    readonly property QtObject node: QtObject {
        property real   width:              200
        property real   height:             150
        property real   opacity:            1.0
        property real   defaultOpacity:     0.8
        property real   selectedOpacity:    0.8

        property int    overviewFontSize:   60
        property int    borderWidth:        2
        property int    fontSizeTitle:      10
        property int    fontSize:           9

        property string color:              "pink"
        property string borderLockColor:    "gray"

    }

    property bool snapEnabled: false

    readonly property var nodeIcons: [
        "\ue4e2",       // General
        "\uf04b",       // Root
        "\uf54b",       // Step
        "\ue57f",       // Transition
        "\uf2db",       // Macro
        "\uf04b"        // Custom
    ]

    readonly property var nodeColors: [
        "#444",       // General
        "#333",       // Root
        "#3D9798",    // Step
        "#625192",    // Transition
        "#9D9E57",    // Macro
        "#333",       // Custom
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
        "MacroNode",            // Macro
        "RootNode",             // Custom
    ]

    //! Node type string list to show nodeTypes text.
    readonly property var objectTypesString: [
        "General",          // General
        "Root",             // Root
        "Step",             // Step
        "Transition",       // Transition
        "Macro",            // Macro
        "Root",             // Custom
        "Link",             // Link

        "Unknown"             // Unknown
    ]

    readonly property string unknown: "Unknown"

    //! Background grid properties
    readonly property QtObject backgroundGrid: QtObject {
        readonly property int spacing:    20
        readonly property double opacity: 0.65
    }

    //! Radius
    readonly property QtObject radiusAmount: QtObject {
        readonly property double nodeOverview:   20
        readonly property double blockerNode:    10
        readonly property double confirmPopup:   10
        readonly property double nodeView:       10
        readonly property double linkView:       5
        readonly property double itemButton:     5
        readonly property double toolTip:        4
    }

    //! Font
    readonly property QtObject fontType: QtObject {
        readonly property string roboto:   "Roboto"
        readonly property string font6Pro: "Font Awesome 6 Pro"
    }
}
