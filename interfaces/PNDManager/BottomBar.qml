import QtQuick 1.1

Rectangle {
  id: bar

  default property alias icons: iconRow.children
  property alias backArrowVisible: backArrow.visible
  property bool syncing: false
  color: "#111"

  signal back()
  signal reload()

  MouseArea { anchors.fill: parent; onPressed: mouse.accepted = true; }

  Row {
    id: iconRow
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: childrenRect.width
    anchors.margins: 4
    spacing: 32
  }


  Item {
    id: backArrow
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    width: height

    Image {
      source: mouseArea.pressed || mouseArea.hover ? "img/arrow_left_white_32x32.png" : "img/arrow_left_32x32.png"
      smooth: true
      anchors.margins: 16
      anchors.fill: parent
      fillMode: Image.PreserveAspectFit
    }
    MouseArea {
      id: mouseArea
      property bool hover: false
      anchors.fill: parent
      hoverEnabled: true
      onEntered: hover = true
      onExited: hover = false
      onClicked: bar.back()
    }
  }

  Item {
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    width: height

    Image {
      NumberAnimation on rotation {
        id: syncAnimation
        from: 0
        to: 360
        loops: Animation.Infinite
        duration: 2000
        alwaysRunToEnd: true
        running: syncing
      }

      source: reloadMouseArea.pressed || reloadMouseArea.hover ? "img/reload_alt_white_24x28.png" : "img/reload_alt_24x28.png"
      smooth: true
      anchors.margins: 16
      anchors.fill: parent
      fillMode: Image.PreserveAspectFit
    }
    MouseArea {
      id: reloadMouseArea
      property bool hover: false
      anchors.fill: parent
      hoverEnabled: true
      onEntered: hover = true
      onExited: hover = false
      onClicked: bar.reload()
    }
  }
}