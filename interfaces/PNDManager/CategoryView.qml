import QtQuick 1.1

import "util.js" as Utils
import "theme.js" as Theme

View {
  id: view
  property string categories
  property QtObject pndManager
  property bool sortByTitle: true
  property QtObject filteredPackages: pndManager.packages.inCategory(categories).notInstalled()
  property QtObject filteredAndSortedPackages: sortByTitle ? filteredPackages.sortedByTitle() : filteredPackages.sortedByLastUpdated()
  Keys.forwardTo: packageList

  onOkButton: packageList.openCurrent()
  onSelectButton: view.sortByTitle = !view.sortByTitle

  PackageList {
    id: packageList
    columns: 2
    pndManager: view.pndManager
    model: filteredAndSortedPackages.titleContains(search.text).all()
    anchors.fill: parent

    Keys.priority: Keys.AfterItem
    Keys.forwardTo: [ui, search]

    onCurrentIndexChanged: if(currentIndex < columns) positionViewAtBeginning()

    header: Item {
      height: 64
      width: packageList.width
      Row {
        spacing: 32
        anchors.centerIn: parent

        Text {
          text: "Sorting:"
          anchors.verticalCenter: parent.verticalCenter
          font.pixelSize: 16
        }
        Rectangle {
          property bool selected: view.sortByTitle
          width: sortByTitleText.paintedWidth + 32
          height: 48
          color: selected ? "#555" : "#eee"
          radius: 8
          Text {
            anchors.centerIn: parent
            id: sortByTitleText
            text: "alphabetical"
            color: parent.selected ? "white" : "black"
            font.pixelSize: 16
          }

          MouseArea {
            anchors.fill: parent
            onClicked: view.sortByTitle = true
          }
        }

        Rectangle {
          property bool selected: !view.sortByTitle
          width: sortByDateText.paintedWidth + 32
          height: 48
          color: selected ? "#555" : "#eee"
          radius: 8
          Text {
            anchors.centerIn: parent
            id: sortByDateText
            text: "last updated"
            color: parent.selected ? "white" : "black"
            font.pixelSize: 16
          }

          MouseArea {
            anchors.fill: parent
            onClicked: view.sortByTitle = false
          }
        }

        GuiHint {
          control: "select"
          anchors.verticalCenter: parent.verticalCenter
          width: 32
          height: 32
        }
      }
    }


    delegate: PackageDelegate {
      pnd: modelData
      height: packageList.cellHeight
      width: packageList.cellWidth

      onClicked: {
        packageList.currentIndex = index;
        packageList.openCurrent();
      }

      Text {
        text: modelData.author.name + "\n" + (view.sortByTitle ? Utils.prettySize(modelData.size) : Utils.prettySize(modelData.size) + " (updated " + Utils.prettyLastUpdatedString(modelData.modified) + ")")
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

