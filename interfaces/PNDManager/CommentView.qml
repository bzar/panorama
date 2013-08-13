import QtQuick 2.0
import "util.js" as Utils

View {
  viewTitle: "Comments"

  property QtObject pnd: pnd

  Keys.forwardTo: commentList

  Connections {
    target: pndManager
    onPackagesChanged: pnd.reloadComments()
  }

  Notification {
    id: commentErrorNotification
    text: "Error adding comment!"
    anchors.centerIn: parent
    z: 2
  }

  Notification {
    id: commentDeleteErrorNotification
    text: "Error deleting comment!"
    anchors.centerIn: parent
    z: 2
  }

  onOkButton: if(removeConfirmation.visible) removeConfirmation.yes()
  onRemoveButton: if(removeConfirmation.visible) removeConfirmation.no()

  ConfirmationDialog {
    property QtObject comment;
    id: removeConfirmation
    message: "Remove comment?"
    onYes: {
      spinnerImage.visible = true;
      pnd.deleteComment(comment);
    }
    z: 2
  }
  Rectangle {
    id: inputContainer
    visible: loggedIn
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: visible ? inputBox.height + 32 : 0
    color: "#eee"
    z: 1

    Rectangle {
      id: inputBox
      color: "#fff"
      border.color:  "#ccc"
      border.width: 1
      radius: 8
      height: Math.min((input.lineCount + 1) * input.font.pixelSize, 192)
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 16
      clip: true

      Flickable {
        id: inputFlickable
        anchors.fill: parent
        contentHeight: input.paintedHeight
        anchors.margins: 8
        anchors.rightMargin: inputHint.visible ? 40 : 4

        TextEdit {
          id: input
          anchors.left: parent.left
          anchors.right: parent.right
          font.pixelSize: 20
          activeFocusOnPress: false
          cursorVisible: true
          wrapMode: TextEdit.Wrap
          onCursorRectangleChanged: {
            if(cursorRectangle.y < inputFlickable.contentY) {
              inputFlickable.contentY = cursorRectangle.y;
            } else if(cursorRectangle.y + cursorRectangle.height > inputFlickable.contentY + inputFlickable.height) {
              inputFlickable.contentY = cursorRectangle.y + cursorRectangle.height - inputFlickable.height;
            }
          }

          Keys.onReturnPressed: {
            readOnly = true;
            spinnerImage.visible = true;
            pnd.addComment(text);
          }
        }
      }
    }

    GuiHint {
      id: inputHint
      control: "keyboard-enter"
      anchors.right: inputBox.right
      anchors.verticalCenter: inputBox.verticalCenter
    }

    Rectangle {
      height: 1
      color: "#ccc"
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
    }

  }

  ListView {
    id: commentList
    model: pnd.comments

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: inputContainer.bottom
    anchors.bottom: parent.bottom

    spacing: 16
    anchors.margins: 16

    Keys.forwardTo: loggedIn ? [ui, input] : ui
    Keys.priority: Keys.BeforeItem

    Component.onCompleted: {
      if(pnd.comments.length === 0) {
        pnd.reloadComments();
      } else {
        spinnerImage.visible = false;
      }
    }

    NumberAnimation {
      id: scrollAnimation
      target: commentList
      property: "contentY"
      duration: 200;
      easing.type: Easing.InOutQuad
    }

    Keys.onDownPressed: {
      if(contentHeight > height) {
        scrollAnimation.to = Math.min(contentHeight, contentY + height/2);
        scrollAnimation.start();
      }
      event.accepted = true;
    }

    Keys.onUpPressed: {
      if(contentHeight > height) {
        scrollAnimation.to = Math.max(0, contentY - height/2);
        scrollAnimation.start();
      }
      event.accepted = true;
    }

    delegate: Column {
      anchors.left: parent.left
      anchors.right: parent.right
      spacing: 8
      Item {
        height: childrenRect.height
        anchors.left: parent.left
        anchors.right: parent.right

        Text {
          text: username
          font.italic: true
          anchors.left: parent.left
          anchors.right: parent.right
          font.pixelSize: 14
        }

        Image {
          anchors.right: commentTimestamp.left
          anchors.rightMargin: 8
          visible: username === usernameSetting.value
          source: "img/x_alt_32x32.png"
          width: 16
          height: 16
          smooth: true
          fillMode: Image.PreserveAspectFit

          MouseArea {
            anchors.fill: parent
            enabled: !spinnerImage.visible
            onClicked: {
              removeConfirmation.comment = modelData;
              removeConfirmation.show();
            }
          }
        }

        Text {
          id: commentTimestamp
          anchors.right: parent.right
          text: Utils.prettyLastUpdatedString(timestamp)
          font.italic: true
          font.pixelSize: 14
        }
      }
      Text {
        text: content
        anchors.left: parent.left
        anchors.right: parent.right
        wrapMode: Text.WordWrap
        font.pixelSize: 16
      }
      Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#eee"
      }
    }

    SpinnerImage {
      id: spinnerImage
      anchors.centerIn: parent

      Connections {
        target: pnd
        onReloadCommentsDone: spinnerImage.visible = false
        onAddCommentDone: {
          input.text = "";
          input.readOnly = false;
          pnd.reloadComments();
        }
        onAddCommentFail: {
          commentErrorNotification.show();
          input.readOnly = false;
          spinnerImage.visible = false;
        }
        onDeleteCommentDone: {
          pnd.reloadComments();
        }
        onDeleteCommentFail: {
          commentDeleteErrorNotification.show();
          spinnerImage.visible = false;
        }
      }
    }
  }
}
