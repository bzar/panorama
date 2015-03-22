import QtQuick 1.1

FocusScope {
  default property alias control: container.children
  property alias title: titleText.text
  property alias image: titleImage.source
  height: childrenRect.height
  Item {
    id: titleContainer
    height: childrenRect.height
    width: 293
    anchors.left: parent.left

    Text {
      id: titleText
      font.pixelSize: 20
      font.letterSpacing: 2
      color: "#e4e4e4"
    }
    Image {
      id: titleImage
    }
  }

  Item {
    id: container
    height: childrenRect.height
    anchors.left: titleContainer.right
    anchors.right: parent.right
  }
  MouseArea {
    anchors.fill: parent

    onPressed: {
      parent.focus = true;
      mouse.accepted = false;
    }
    onReleased: mouse.accepted = false
    onDoubleClicked: mouse.accepted = false
    onPositionChanged: mouse.accepted = false
  }
}
