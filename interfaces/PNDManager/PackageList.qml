import QtQuick 1.1

GridView {
  id: packageList
  property QtObject pndManager
  property variant packages
  property int columns: 2
  anchors.fill: parent
  model: packages
  boundsBehavior: GridView.DragOverBounds

  Component { id: packageView; PackageView {} }

  function openCurrent() {
    var view = stack.push(packageView, {
                            "pnd": packages[currentIndex],
                            "viewTitle": packages[currentIndex].title,
                            "pndManager": pndManager
                          });
  }

  cellWidth: width / columns - width%columns
  cellHeight: 64
  delegate: Rectangle {
    height: packageList.cellHeight
    width: packageList.cellWidth
    color: Qt.hsla(parseFloat(index)/packageList.count, 0.5, GridView.isCurrentItem ? 0.7 : 0.5, 1.0)
    border.width: GridView.isCurrentItem ? 2 : 0
    border.color: Qt.hsla(parseFloat(index)/packageList.count, 0.5, 0.9, 1.0)
    z: GridView.isCurrentItem ? 2 : 1

    Text { text: modelData.title; }

    Image {
      source: modelData.icon
      asynchronous: true
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onEntered: packageList.currentIndex = index;
      onClicked: {
        packageList.currentIndex = index;
        packageList.openCurrent();
      }
    }
  }

  Rectangle {
    width: 16
    height: packageList.height * packageList.height / packageList.contentHeight
    anchors.right: parent.right
    y: (packageList.height - height) * packageList.contentY / (packageList.contentHeight - packageList.height)
    color: "#111"
    visible: packageList.moving
    z: 1
  }

  Keys.onReturnPressed: openCurrent()
}
