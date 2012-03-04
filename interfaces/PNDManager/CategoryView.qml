import Qt 4.7

View {
    id: view
    property string categories
    property QtObject pndManager

    Keys.forwardTo: packageList

    Rectangle {
        anchors.fill: parent
        color: "white"
        PackageList {
          id: packageList
            packages: pndManager !== null && categories !== null ? pndManager.getPackagesFromCategory(categories) : null
        }
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Backspace) {
            stack.pop()
        }
    }

}

