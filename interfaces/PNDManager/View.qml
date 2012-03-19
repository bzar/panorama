import QtQuick 1.1

Rectangle {
  property QtObject stack: parent.parent
  property string viewTitle

  signal okButton()
  signal installRemoveButton()
  signal upgradeButton()

  height: parent.height
  width: parent.width
  clip: true
  color: "white"
}
