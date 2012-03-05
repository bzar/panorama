import Qt 4.7

Rectangle {
  id: bar

  default property alias icons: iconRow.children

  color: "#111"

  signal back()

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
}
