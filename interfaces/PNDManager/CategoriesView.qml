import Qt 4.7

View {
  property QtObject pndManager

  Keys.forwardTo: categoryList
  ListModel {
    id: categories
    ListElement{ title: "Media"; categoryFilter: "Audio|Video|AudioVideo|Graphics" }
    ListElement{ title: "Developer"; categoryFilter: "Development" }
    ListElement{ title: "Educational"; categoryFilter: "Education" }
    ListElement{ title: "Games"; categoryFilter: "Game" }
    ListElement{ title: "Network"; categoryFilter: "Network" }
    ListElement{ title: "Office"; categoryFilter: "Office" }
    ListElement{ title: "System"; categoryFilter: "Settings|System" }
    ListElement{ title: "Utilities"; categoryFilter: "Utility" }
  }

  Component {
    id: categoryView
    CategoryView {

    }
  }

  Rectangle {
    anchors.fill: parent
    color: "white"

    GridView {
      id: categoryList
      property int columns: 2
      model: categories
      anchors.fill: parent

      function openCurrent() {
        var view = stack.push(categoryView, {pndManager: pndManager, categories: currentItem.filter});
      }

      cellWidth: width/columns
      cellHeight: height/(model.count/columns)

      delegate: Rectangle {
        property string filter: categoryFilter
        width: categoryList.cellWidth
        height: categoryList.cellHeight
        color: Qt.hsla(parseFloat(index)/categoryList.count, 0.5, GridView.isCurrentItem ? 0.7 : 0.5, 1.0)
        border.width: GridView.isCurrentItem ? 2 : 0
        border.color: Qt.hsla(parseFloat(index)/categoryList.count, 0.5, 0.9, 1.0)
        z: GridView.isCurrentItem ? 2 : 1
        scale: GridView.isCurrentItem ? 1.05 : 1.0

        Behavior on scale {
          PropertyAnimation { duration: 100 }
        }

        Text {
          text: title
          font.pixelSize: 32
          anchors.centerIn: parent
        }

        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          onEntered: categoryList.currentIndex = index;
          onClicked: {
            categoryList.currentIndex = index;
            categoryList.openCurrent();
          }
        }
      }

      Keys.onReturnPressed: openCurrent()
    }
  }



}

