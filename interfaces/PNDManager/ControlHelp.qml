// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Row {
  property alias control: guihint.control
  property alias label: label.text
  height: 32
  spacing: 16
  GuiHint {
    id: guihint
    height: parent.height
    width: height
    visible: true
  }
  Text {
    id: label
    font.pixelSize: 2*parent.height/3
    anchors.verticalCenter: parent.verticalCenter
  }
}
