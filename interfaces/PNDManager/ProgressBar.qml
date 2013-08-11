import QtQuick 2.0

Item {
  property int minimumValue: 0
  property int maximumValue: 1
  property int value: 0

  property alias radius: bar.radius
  property alias border: bar.border
  property alias color: bar.color

  Rectangle {
    id: bar
    width: 2 * radius + (parent.width - 2 * radius) * value / (maximumValue - minimumValue)
    height: parent.height
  }
}
