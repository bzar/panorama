import Qt 4.7

Image {
  id: icon
  property string normalImage
  property string highlightImage
  property bool highlight: false
  property bool hover: false
  signal clicked()
  source: highlight || hover ? highlightImage : normalImage
  height: parent.height
  fillMode: Image.PreserveAspectFit
  smooth: true
  MouseArea {
    anchors.fill: parent;
    onClicked: icon.clicked()
    hoverEnabled: true
    onEntered: icon.hover = true
    onExited: icon.hover = false
  }
}
