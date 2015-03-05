import QtQuick 1.1

FocusScope {
  default property alias control: container.children
  property alias title: titleText.text
  height: childrenRect.height
  Text {
    id: titleText
    anchors.left: parent.left
    font.pixelSize: 20
    font.letterSpacing: 2
    width: 300
    color: "#eee"
  }
  Item {
    id: container
    height: childrenRect.height
    anchors.left: titleText.right
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
