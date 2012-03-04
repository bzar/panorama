import Qt 4.7

View {
  property QtObject pnd

  Component {
    id: content
    Rectangle {
      anchors.fill: parent
      color: "white"
      Text { text: pnd.title }
    }
  }

  Loader {
    anchors.fill: parent
    sourceComponent: pnd ? content : null
  }

  Keys.onPressed: {
      if(event.key === Qt.Key_Backspace) {
          stack.pop()
      }
  }
}

