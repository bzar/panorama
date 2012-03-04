import Qt 4.7

GridView {
  id: packageList
  property variant packages
  property int columns: 2
  anchors.fill: parent
  model: packages

  Component {
    id: packageView
    PackageView {

    }
  }

  function openCurrent() {
    var view = stack.push(packageView, {pnd: packages[currentIndex]});
  }

  cellWidth: width / columns - 1
  cellHeight: 64
  delegate: Rectangle {
    height: packageList.cellHeight
    width: packageList.cellWidth
    Text { text: modelData.title; }

    color: Qt.hsla(parseFloat(index)/packageList.count, 0.5, GridView.isCurrentItem ? 0.7 : 0.5, 1.0)
    border.width: GridView.isCurrentItem ? 2 : 0
    border.color: Qt.hsla(parseFloat(index)/packageList.count, 0.5, 0.9, 1.0)
    z: GridView.isCurrentItem ? 2 : 1

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onEntered: categoryList.currentIndex = index;
      onClicked: {
        packageList.currentIndex = index;
        packageList.openCurrent();
      }
    }
  }

  Keys.onReturnPressed: openCurrent()
}
