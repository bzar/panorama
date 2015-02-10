import QtQuick 1.1

FocusScope {
  property QtObject stack: parent.parent
  property string viewTitle

  height: parent.height
  width: parent.width
  clip: true
  signal okButton()
  signal removeButton()
  signal installUpgradeButton()
  signal selectButton()
  Rectangle {
    anchors.fill: parent
    color: "white"
  }
}
