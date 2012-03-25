import QtQuick 1.1

import "util.js" as Utils

View {
  id: view
  property string categories
  property QtObject pndManager
  property QtObject filteredPackages: pndManager.packages.inCategory(categories).notInstalled().sortedByTitle()
  Keys.forwardTo: packageList

  onOkButton: packageList.openCurrent()

  PackageList {
    id: packageList
    columns: 2
    pndManager: view.pndManager
    model: filteredPackages.titleContains(search.text).all()
    anchors.fill: parent
    anchors.margins: 8

    Keys.priority: Keys.AfterItem
    Keys.forwardTo: [ui, search]

    delegate: PackageDelegate {
      pnd: modelData
      height: packageList.cellHeight
      width: packageList.cellWidth

      onClicked: {
        packageList.currentIndex = index;
        packageList.openCurrent();
      }

      Text {
        id: authorText
        text: modelData.author.name
        font.pixelSize: 14
      }
      Text {
        anchors.top: authorText.bottom
        text: Utils.prettySize(modelData.size)
        font.pixelSize: 14
      }
    }
  }

  Rectangle {
    opacity: 0.8
    height: 32
    anchors.bottomMargin: search.text != "" ? 0 : -(height+1)
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    color: "#eee"
    border {
      color: "#444"
      width: 1
    }

    TextInput {
      id: search
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 4
      font.pixelSize: 14
      activeFocusOnPress: false
    }
  }
}

