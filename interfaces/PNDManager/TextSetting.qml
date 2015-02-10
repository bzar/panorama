import QtQuick 1.1
import "theme.js" as Theme

FocusScope {
  property QtObject setting
  Rectangle {
    id: rect
    radius: height / 8
    color: "#fff"
    border.color: "#111"
    border.width: height / 32
    anchors.fill: parent

    TextInput {
      id: input
      text: setting.value
      onTextChanged: setting.value = text
      selectByMouse: true
      selectedTextColor: "#fff"
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
      anchors.leftMargin: parent.height / 8
      anchors.rightMargin: parent.height / 8
    }
  }
}
