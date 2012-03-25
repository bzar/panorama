import QtQuick 1.1

Image {
  property string control

  source: control ? "img/guihints/p02_" + control + ".png" : ""
  width: 24
  height: 24
  smooth: true
  visible: showHints.value
}
