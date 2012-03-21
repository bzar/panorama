import QtQuick 1.1

import "util.js" as Utils

GridView {
  id: packageList
  property QtObject pndManager
  property variant packages
  property int columns: 2
  model: packages.sortedByTitle().all()
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
    x: packageList.currentItem.x
    y: packageList.currentItem.y
  }
  highlightFollowsCurrentItem: false

  delegate: Item {
    height: packageList.cellHeight
    width: packageList.cellWidth

    Image {
      id: icon
      source: modelData.icon
      asynchronous: true
      height: 48
      width: 48
      fillMode: Image.PreserveAspectFit
      sourceSize {
        height: 48
        width: 48
      }
    }

    Text {
      id: title
      text: modelData.title
      anchors.left: icon.right
      anchors.right: parent.right
      elide: Text.ElideRight
      font.pixelSize: 16
      font.underline: true
      anchors.leftMargin: 8
    }

    Text {
      text: Utils.prettySize(modelData.size)
      anchors.left: icon.right
      anchors.right: parent.right
      anchors.top: title.bottom
      font.pixelSize: 14
      anchors.leftMargin: 8
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
}
