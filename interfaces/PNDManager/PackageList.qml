import QtQuick 2.0

GridView {
  id: packageList
  property QtObject pndManager
  property variant packages
  property int columns
  boundsBehavior: GridView.DragOverBounds

  Component { id: packageView; PackageView {} }

  function openCurrent() {
    if(currentIndex < model.length)
    var view = stack.push(packageView, {
                            "pnd": model[currentIndex],
                            "viewTitle": model[currentIndex].title,
                            "pndManager": pndManager
                          });
  }

  cellWidth: width / columns - width%columns
  cellHeight: 64
  highlight: Rectangle {
    width: packageList.cellWidth
    height: packageList.cellHeight
    color: "#ddd"
    radius: 8
    x: packageList.currentItem ? packageList.currentItem.x : 0
    y: packageList.currentItem ? packageList.currentItem.y : 0
    visible: packageList.currentItem !== null

    GuiHint {
      control: "game-b"
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.margins: 4
    }
  }
  highlightFollowsCurrentItem: false

  ScrollBar {
    id: scrollbar
    anchors.right: parent.right
    Connections {
      target: packageList
      onMovementStarted: scrollbar.show()
      onMovementEnded: scrollbar.hide()
      onCurrentIndexChanged: scrollbar.showIfChanged(contentY)
    }
  }
}
