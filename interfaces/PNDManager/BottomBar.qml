import QtQuick 2.0

Rectangle {
  id: bar

  default property alias icons: iconRow.children
  property alias backArrowVisible: backArrow.visible
  property bool syncing: false
  property bool syncError: false
  color: "#111"

  signal back()
  signal reload()

  MouseArea { anchors.fill: parent; onPressed: mouse.accepted = true; }

  Row {
    id: iconRow
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 2
    height: 32
    spacing: 3

  }

  Image {
    source: "img/bottombar/pndme-0.6.1.0-stopper-lef.png"
    anchors.right: iconRow.left
    anchors.rightMargin: 3
    anchors.top: iconRow.top
  }

  Image {
    source: "img/bottombar/pndme-0.6.1.0-stopper-right.png"
    anchors.left: iconRow.right
    anchors.leftMargin: 3
    anchors.top: iconRow.top
  }

  Image {
    id: backArrow
    source: "img/bottombar/pndme-0.6.1.1-return.png"
    anchors.right: iconRow.left
    anchors.rightMargin: 3
    anchors.top: parent.top

    MouseArea {
      id: mouseArea
      anchors.fill: parent
      onClicked: bar.back()
    }
  }

  AnimatedImage {
    id: reloadIcon
    property bool showingSuccess: false
    property bool showingError: false
    signal finished();

    function getSource() {
      if(syncing) {
        return "img/bottombar/pndme-0.6.1.0-update_working.gif";
      } else if(showingSuccess) {
        return "img/bottombar/pndme-0.6.1.0-update_success.gif";
      } else if(syncError) {
        return "img/bottombar/pndme-0.6.1.0-update_failed.png";
      } else {
        return "img/bottombar/pndme-0.6.1.0-update.png";
      }
    }

    source: getSource()

    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    anchors.rightMargin: 16
    onSourceChanged: {
      playing = true;
      paused = false;
    }

    onCurrentFrameChanged: {
      if(currentFrame === frameCount - 1) {
        reloadIcon.finished();
      }
    }

    onFinished: {
      if(showingSuccess) {
        // Pausing is required. Changing the source of a playing
        // AnimatedImage within onCurrentFrameChanged causes a segfault
        paused = true;
        showingSuccess = false;
      }
    }

    Connections {
      target: bar
      onSyncingChanged: reloadIcon.showingSuccess = !syncing
    }

    MouseArea {
      id: reloadMouseArea
      anchors.fill: parent
      onClicked: bar.reload()
    }
  }
}
