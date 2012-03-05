import Qt 4.7

View {
  property QtObject pnd

  Component {
    id: content
    Rectangle {
      anchors.fill: parent
      color: "white"
      Text {
        id: titleText
        text: pnd.title
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.Center
        font.pixelSize: 42
      }

      Row {
        anchors.top: titleText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 16
        Button {
          label: "Install"
          color: "#69D772"
          width: 128
          visible: !pnd.installed
        }
        Button {
          label: "Remove"
          color: "#D76D69"
          width: 128
          visible: pnd.installed
        }
        Button {
          label: "Upgrade"
          color: "#6992D7"
          width: 128
          visible: pnd.installed && pnd.upgrade
        }

      }
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

