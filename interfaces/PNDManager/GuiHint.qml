import QtQuick 2.0

Image {
  property string control

  source: control ? "img/guihints/p02_" + control + ".png" : ""
  width: 40
  height: 40
  smooth: width != 40 || height != 40
  visible: showHints.value
  opacity: 0.93
}
