import QtQuick 1.1

import "util.js" as Utils
import "theme.js" as Theme

View {
  property QtObject pnd
  property QtObject pndManager

  Component { id: installDialog; InstallLocationDialog {} }
  Component { id: previewPictureView; PreviewPictureView {} }
  Component { id: commentView; CommentView {} }
  Component { id: ratingView; RatingView {} }

  Keys.forwardTo: textArea
  Keys.priority: Keys.AfterItem

  onOkButton: removeConfirmation.visible ? removeConfirmation.yes() : showPreviewPictures()

  Keys.onReturnPressed: execute()
  Keys.onPressed: {
    if(event.key === Qt.Key_C) showComments();
    else if(event.key === Qt.Key_R) showRatingDialog();
  }

  onInstallUpgradeButton: {
    if(removeConfirmation.visible)
      return
    else if(pnd.hasUpgrade)
      upgrade()
    else if(!pnd.installed)
      showInstallDialog()
  }

  onRemoveButton: {
    if(removeConfirmation.visible)
      removeConfirmation.no()
    else if(pnd.isDownloading)
      pnd.cancelDownload()
    else if(pnd.installed)
      removeConfirmation.show()
  }

  Connections {
    target: pnd
    onDownloadStarted: spinner.hide()
  }

  ConfirmationDialog {
    id: removeConfirmation
    message: "Remove " + pnd.title + "?"
    onYes: {
      spinner.show();
      pnd.remove();
      spinner.hide();
    }
    z: 10
  }

  function showPreviewPictures() {
    if(pnd.previewPictures.length > 0) {
      stack.push(previewPictureView, { "previewPictures": pnd.previewPictures });
    }
  }

  function showComments() {
    stack.push(commentView, {"pnd": pnd});
  }

  function showRatingDialog() {
    stack.push(ratingView, {"pnd": pnd});
  }

  function showInstallDialog() {
    if(!pnd.installed && !pnd.isDownloading) {
      stack.push(installDialog, {"pndManager": pndManager, "pnd": pnd});
    }
  }

  function upgrade() {
    if(pnd.installed && pnd.hasUpgrade && !pnd.isDownloading) {
      spinner.show();
      pnd.upgrade();
    }
  }

  function execute() {
    if(!pndManager.applicationRunning) {
      pndManager.execute(pnd.id)
    }
  }

  Text {
    id: titleText
    text: pnd.title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    elide: Text.ElideRight
    horizontalAlignment: Text.Center
    font.pixelSize: 42
  }

  Row {
    id: buttons
    anchors.top: titleText.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: pnd.installed && !pnd.isDownloading && pnd.hasUpgrade ? 8 : 16
    Button {
      label: "Install"
      sublabel: Utils.prettySize(pnd.size)
      control: "game-y"
      color: Theme.colors.install
      width: 256
      height: 64
      radius: 4
      visible: !pnd.installed && !pnd.isDownloading && pnd.remoteVersion !== null
      onClicked: showInstallDialog()
    }
    Button {
      label: "Remove"
      sublabel: Utils.prettySize(pnd.size)
      control: "game-a"
      color: Theme.colors.remove
      width: 256
      height: 64
      radius: 4
      visible: pnd.installed && !pnd.isDownloading
      onClicked: removeConfirmation.show()
    }
    Button {
      label: "Upgrade"
      sublabel: pnd.hasUpgrade ? Utils.versionString(pnd.localVersion) + " → " + Utils.versionString(pnd.remoteVersion) + " (" + Utils.prettySize(pnd.upgradeCandidate.size) + ")" : ""
      control: "game-y"
      color: Theme.colors.upgrade
      width: 256
      height: 64
      radius: 4
      visible: pnd.installed && pnd.hasUpgrade && !pnd.isDownloading
      onClicked: upgrade()
    }
    Button {
      label: "Launch"
      sublabel: Utils.prettySize(pnd.size)
      control: "keyboard-enter"
      color: Theme.colors.install
      width: 256
      height: 64
      radius: 4
      visible: pnd.installed && !pnd.isDownloading
      onClicked: execute()
      enabled: !pndManager.applicationRunning
    }

    Column {
      width: 256
      height: 64
      visible: pnd.isDownloading
      Text {
        text: "Installing..."
        anchors.left: parent.left
        anchors.margins: 16
      }
      Rectangle {
        id: progressBarContainer
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#ddd"
        radius: 24
        height: 48

        ProgressBar {
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          anchors.margins: 8
          height: 32
          radius: 16
          color: "#333"
          minimumValue: 0
          maximumValue: pnd.bytesToDownload
          value: pnd.bytesDownloaded
        }

        Image {
          source: "img/x_alt_32x32.png"
          anchors.left: parent.right
          anchors.verticalCenter: parent.verticalCenter
          anchors.margins: 16

          GuiHint {
            control: "game-a"
            anchors.left: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.margins: 8
          }

          MouseArea {
            anchors.fill: parent
            onClicked: pnd.cancelDownload()
          }
        }
      }

      Item {
        anchors.right: parent.right
        anchors.margins: 16
        property variant progress: Utils.prettyProgress(pnd.bytesDownloaded, pnd.bytesToDownload)
        Text {
          text: parent.progress.value
          anchors.right: totalSize.left
        }
        Text {
          id: totalSize
          anchors.right: parent.right
          text: " / " + parent.progress.size + " " + parent.progress.unit
        }
      }
    }
  }

  Rectangle {
    height: 1
    color: "#eee"
    anchors.bottom: textArea.top
    anchors.left: textArea.left
    anchors.right: textArea.right
  }

  Flickable {
    id: textArea
    anchors.top: buttons.bottom
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.margins: 16
    contentHeight: textAreaContents.height
    contentWidth: width
    clip: true
    interactive: !removeConfirmation.visible
    NumberAnimation {
      id: scrollAnimation
      target: textArea;
      property: "contentY"
      duration: 200;
      easing.type: Easing.InOutQuad
    }

    Keys.onDownPressed: {
      if(contentHeight > height) {
        scrollAnimation.to = Math.min(contentHeight - height, contentY + height/2);
        scrollAnimation.start();
      }
    }

    Keys.onUpPressed: {
      if(contentHeight > height) {
        scrollAnimation.to = Math.max(0, contentY - height/2);
        scrollAnimation.start();
      }
    }

    Column {
      id: textAreaContents
      anchors.left: parent.left
      anchors.right: parent.right
      height: childrenRect.height
      spacing: 16

      Item {
        anchors.left: parent.left
        anchors.right: parent.right
        height: childrenRect.height

        Image {
          id: icon
          source: pnd.installed ? "image://pnd/" + pnd.id : pnd.icon
          asynchronous: true
          sourceSize.width: 48
          anchors.top: parent.top
          anchors.topMargin: 4
        }

        Column {
          height: childrenRect.height
          anchors.left: icon.right
          anchors.right: parent.right
          anchors.leftMargin: 8

          PackageInfoText {
            anchors.left: parent.left
            anchors.right: parent.right
            label: "Author:"
            text: pnd.author.name
          }

          PackageInfoText {
            anchors.left: parent.left
            anchors.right: parent.right
            label: "Rating:"
            text: pndUtils.createRatingString(pnd)
          }

          PackageInfoText {
            anchors.left: parent.left
            anchors.right: parent.right
            label: "Updated:"
            text: Utils.prettyLastUpdatedString(pnd.modified)
          }
        }
      }

      Text {
        text: pnd.description
        anchors.left: parent.left
        anchors.right: parent.right
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font.pixelSize: 14
      }

      Text {
        text: "Additional information:"
        visible: additionalInformation.text != ""
        anchors.left: parent.left
        anchors.right: parent.right
        font.pixelSize: 14
        height: paintedHeight + 8
        verticalAlignment: Text.AlignBottom
        font.weight: Font.DemiBold
      }

      Text {
        id: additionalInformation
        text: pnd.info
        anchors.left: parent.left
        anchors.right: parent.right
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        font.pixelSize: 14
      }

    }
  }

  Rectangle {
    height: 1
    color: "#eee"
    anchors.top: textArea.bottom
    anchors.left: textArea.left
    anchors.right: textArea.right
  }

  Rectangle {
    height: 1
    color: "#eee"
    anchors.bottom: imageArea.top
    anchors.left: imageArea.left
    anchors.right: imageArea.right
  }

  Item {
    id: imageArea
    anchors.top: buttons.bottom
    anchors.bottom: secondaryButtons.top
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.margins: 4
    anchors.topMargin: 16
    clip: true

    Image {
      id: image
      anchors.centerIn: parent
      anchors.bottomMargin: 4
      anchors.topMargin: 4
      source: pnd.previewPictures.length > 0 ? pnd.previewPictures[0].src : ""
      asynchronous: true

      Component.onCompleted: {
        sourceSize.width = parent.width
      }

      Text {
          anchors.centerIn: parent
          visible: image.source == "" || image.status != Image.Ready
          text: image.source != "" ? parseInt(image.progress * 100) + "%" : "No preview"
          font.pixelSize: 24
          color: "#777"
      }

      MouseArea {
        anchors.fill: parent
        onClicked: showPreviewPictures()
      }
    }
    Rectangle {
      anchors.top: parent.top
      anchors.right: parent.right
      anchors.margins: 8
      visible: pnd.previewPictures.length > 0
      height: 32
      width: showPreviewPicturesText.paintedWidth + showPreviewPicturesIcon.width + 16
      radius: height/4
      color: Qt.rgba(0.8, 0.8, 0.8, 0.3)

      Row {
        anchors.centerIn: parent
        height: 24
        spacing: 4
        Text {
          id: showPreviewPicturesText
          text: "Show more"
          font.pixelSize: 18
          style: Text.Outline
          styleColor: "#111"
          color: "#fff"
          anchors.verticalCenter: parent.verticalCenter
        }
        GuiHint {
          id: showPreviewPicturesIcon
          control: "game-b"
          anchors.verticalCenter: parent.verticalCenter
        }
      }
    }
  }

  Rectangle {
    height: 1
    color: "#eee"
    anchors.top: imageArea.bottom
    anchors.left: imageArea.left
    anchors.right: imageArea.right
  }

  StretchRow {
    id: secondaryButtons
    anchors.bottom: parent.bottom
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.margins: 4
    spacing: 4
    height: childrenRect.height

    Button {
      id: ratingButton
      label: pnd.ownRating ? pndUtils.createOwnRatingString(pnd) : "Rate PND"
      height: 32
      control: "keyboard-r"
      radius: 4
      color: "#B5B559"
      onClicked: showRatingDialog()


      Component.onCompleted: {
        pnd.reloadOwnRating();
      }
    }

    Button {
      id: commentsButton
      property int numberOfComments: -1
      label: numberOfComments < 0 ? "Comments" : "Comments (" + numberOfComments + ")"
      color: "#555"
      control: "keyboard-c"
      radius: 4
      height: 32
      onClicked: showComments()

      Component.onCompleted: {
        if(pnd.comments.length === 0)
          pnd.reloadComments();
      }

      Connections {
        target: pnd
        onReloadCommentsDone: commentsButton.numberOfComments = pnd.comments.length
      }
    }
  }
}

