import QtQuick 1.1

import "util.js" as Utils

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
  }
  highlightFollowsCurrentItem: false

  delegate: PackageDelegate {
    pnd: modelData
    height: packageList.cellHeight
    width: packageList.cellWidth

    onClicked: {
      packageList.currentIndex = index;
      packageList.openCurrent();
    }

    Text {
      text: Utils.prettySize(modelData.size)
      font.pixelSize: 14
    }
  }

  ScrollBar {
    id: scrollbar
  }
}
