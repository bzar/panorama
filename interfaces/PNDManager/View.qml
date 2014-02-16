import QtQuick 2.0

Rectangle {
  property QtObject stack: parent.parent
  property string viewTitle

  signal okButton()
  signal removeButton()
  signal installUpgradeButton()
  signal selectButton()

  height: parent.height
  width: parent.width
  clip: true
  color: "white"
}
