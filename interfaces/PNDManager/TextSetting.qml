import QtQuick 1.1
import "theme.js" as Theme

FocusScope {
  property QtObject setting
  Rectangle {
    id: rect
    radius: height / 4
    color: "#ddd"
    border.color: "#555"
    border.width: height / 64.0
    anchors.fill: parent

    TextInput {
      id: input
      text: setting.value
      onTextChanged: setting.value = text
      selectByMouse: true
      selectedTextColor: "#ddd"
      selectionColor: "#88f"
      Connections {
        target: setting
        onValueChanged: input.text = setting.value
      }

      focus: true
      font.pixelSize: 2 * parent.height / 3
      anchors.fill: parent
      anchors.topMargin: parent.height / 32
      anchors.bottomMargin: parent.height / 32
      anchors.leftMargin: rect.radius
      anchors.rightMargin: rect.radius
    }
  }
}
