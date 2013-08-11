import QtQuick 2.0

Image {
  id: icon
  property string normalImage
  property string highlightImage
  property bool highlight: false
  property alias leftHintVisible: leftHint.visible
  property alias rightHintVisible: rightHint.visible

  signal clicked()
  source: highlight ? highlightImage : normalImage
  MouseArea {
    anchors.fill: parent;
    onClicked: icon.clicked()
  }

  Image {
    id: leftHint
    source: "img/bottombar/pndme-0.6.1.0-catleft.png"
    anchors.right: parent.right
    anchors.rightMargin: -1
    anchors.bottom: parent.bottom
  }
  Image {
    id: rightHint
    source: "img/bottombar/pndme-0.6.1.0-catright.png"
    anchors.left: parent.left
    anchors.leftMargin: -1
    anchors.bottom: parent.bottom
  }

}
