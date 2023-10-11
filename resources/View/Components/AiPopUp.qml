import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Universal
import QtQuick.Dialogs
import NodeLink



/*! ***********************************************************************************************
 * Ai help popup
 * ************************************************************************************************/

Popup {
    id: popUp

    /* Property Declarations
     * ****************************************************************************************/
    property SceneSession   sceneSession:    null

    property string         selectedText

    property string         wholeText:       answer.text

    property bool           isAnswerLoading: false

    /* Object Properties
     * ****************************************************************************************/
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    parent: Overlay.overlay
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    width: 350
    height: 550
    padding: 8
    modal: true

    onOpened:{
        // Get key events
        mainRect.forceActiveFocus();
    }

    onClosed: sceneSession?.sceneForceFocus();

    /* Signals
     * ****************************************************************************************/
    signal insertSelectedText();
    signal insertWholeText();

    /* Children
     * ****************************************************************************************/
    background: Rectangle {
        id: background

        opacity: 0.95
        color: "black"
        radius: NLStyle.radiusAmount.confirmPopup
    }

    Rectangle {
        id: mainRect
        anchors.fill: parent
        color: "transparent"

        //! description text
        Item {
            id: promtItem
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9
            height: parent.height * 0.2
            Rectangle {
                id: promptText
                anchors.top: parent.top
                anchors.left: parent.left
                height: 25
                color: "transparent"
                Text {
                    anchors.fill: parent
                    text: "Prompt:"
                    color: "white"
                    font.pixelSize: 12
                }
            }
            ScrollView {
                id: promptResult
                anchors.top: promptText.bottom
                anchors.left: parent.left
                width: parent.width
                height: parent.height - promptText.height - submitBtn.height

                ScrollBar.vertical: HorizontalScrollBar {}


                NLTextArea {
                    id: promptQuestion
                    placeholderText: "Prompt"
                    color: "white"
                    wrapMode: Text.Wrap
                    background: Rectangle{
                        color: "transparent"
                        border.color: "white"
                        border.width: 1
                        radius: 5
                    }

                }

            }


            Button {
                id: submitBtn
                width: 70
                height: 20
                anchors.top: promptResult.bottom
                anchors.topMargin: 8
                anchors.right: parent.right
                anchors.rightMargin: 2
                enabled: !popUp.isAnswerLoading

                background: Rectangle {
                    color: submitBtn.enabled && (submitBtn.hovered)? Qt.lighter("gray", 1.5) : "gray"
                    radius: NLStyle.radiusAmount.confirmPopup
                }
                text: qsTr("Submit")

                font.family: NLStyle.fontType.roboto
                font.pointSize: insertBtn.enabled && insertBtn.hovered ? 10 : 8

                onClicked: {
                    popUp.isAnswerLoading = true
                    answer.text = ""
                    var userQuestion = promptQuestion.text;

                    var xhr = new XMLHttpRequest();
                    xhr.open("POST", "https://api.openai.com/v1/chat/completions", true);
                    xhr.setRequestHeader("Content-Type", "application/json");
                    xhr.setRequestHeader("Authorization", "Bearer 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");
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === XMLHttpRequest.DONE) {
                            if (xhr.status === 200) {
                                var response = JSON.parse(xhr.responseText);
                                var assistantMessage = response.choices[0].message.content;
                                answer.text = assistantMessage
                            } else {
                                answer.text = "Error: Unable to retrieve a response.";
                            }
                            popUp.isAnswerLoading = false
                        }
                    };
                    var requestData = JSON.stringify({
                            model: "gpt-3.5-turbo",
                            messages: [
                                {
                                    role: "system",
                                    content: "You are a helpful assistant."
                                },
                                {
                                    role: "user",
                                    content: userQuestion
                                }
                             ],
                            max_tokens: 1000
                        });
                    xhr.send(requestData);
                }
            }


        }

        Item {
            id: answerItem
            anchors.top: promtItem.bottom
            anchors.topMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.9
            height: parent.height * 0.67
            Rectangle {
                id: answerText
                anchors.top: parent.top
                anchors.left: parent.left
                height: 25
                color: "transparent"
                Text {
                    anchors.fill: parent
                    text: "Answer:"
                    color: "white"
                    font.pixelSize: 12
                }
            }
            ScrollView {
                id: answerResult
                anchors.top: answerText.bottom
                anchors.left: parent.left
                width: parent.width
                height: parent.height - answerText.height

                NLTextArea {
                    id: answer
                    placeholderText: "Answer"
                    color: "white"
                    wrapMode: Text.Wrap
                    readOnly: true
                    background: Rectangle{
                        color: "transparent"
                        border.color: "white"
                        border.width: 1
                        radius: 5
                    }
                    onSelectedTextChanged: {
                        if (answer.selectedText !== "")
                            popUp.selectedText = answer.selectedText
                    }

                }
            }

        }

        //! Button Item
        Item {
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: answerItem.bottom
            anchors.topMargin: 15
            height: 25

            Button {
                id: insertBtn
                width: 70
                anchors.right: insertSelectedTextBtn.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                enabled: !popUp.isAnswerLoading
                background: Rectangle {
                    color: insertBtn.enabled && (insertBtn.hovered)? Qt.lighter("gray", 1.5) : "gray"
                    radius: NLStyle.radiusAmount.confirmPopup
                }
                text: qsTr("Insert")

                font.family: NLStyle.fontType.roboto
                font.pointSize: insertBtn.enabled && insertBtn.hovered ? 10 : 8

                onClicked: {
                   insertWholeText()
                }
            }

            Button {
                id: insertSelectedTextBtn
                width: 150
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: !popUp.isAnswerLoading
                background: Rectangle {
                    color: insertSelectedTextBtn.enabled && (insertSelectedTextBtn.hovered) ? Qt.lighter("gray", 1.5) : "gray"
                    radius: NLStyle.radiusAmount.confirmPopup
                }

                text: qsTr("Insert Selected Text")
                font.family: NLStyle.fontType.roboto
                font.pointSize: insertSelectedTextBtn.enabled && insertSelectedTextBtn.hovered ? 10 : 8
                onClicked: {
                    console.log("hey", answer.selectedText)
                    insertSelectedText()
                }
            }

            Button {
                id: exitBtn
                width: 60
                anchors.left: insertSelectedTextBtn.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5

                background: Rectangle {
                    color: exitBtn.enabled && (exitBtn.hovered) ? Qt.lighter("gray", 1.5) : "gray"
                    radius: NLStyle.radiusAmount.confirmPopup
                }

                text: qsTr("Exit")
                font.family: NLStyle.fontType.roboto
                font.pointSize: exitBtn.enabled && exitBtn.hovered ? 10 : 8
                onClicked: {
                    popUp.close()
                }
            }
        }
    }
}
