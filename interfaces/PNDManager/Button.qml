import QtQuick 1.1

Item {
    id: button
    property color color: "lightgrey"
    property alias label: labelText.text
    property alias sublabel: sublabelText.text
    property alias pressed: mouseArea.pressed
    property alias hovered: mouseArea.hover
    property alias font: labelText.font
    property alias textColor: labelText.color
    property alias enabled: mouseArea.enabled
    property alias radius: rectangle.radius
    property alias border: rectangle.border

    signal clicked();

    width: 64
    height: 32

    Rectangle {
        id: rectangle
        anchors.fill: parent

        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.darker(button.color, pressed ? 1.6 : hovered ? 0.8 : 1.0 ) }
            GradientStop { position: pressed ? 0.2 : 0.8; color: Qt.darker(button.color, pressed ? 1.4 : hovered ? 1.0 : 1.2) }
            GradientStop { position: 1.0; color: Qt.darker(button.color, pressed ? 1.2 : hovered ? 1.6 : 1.4) }
        }

        clip: true

        Column {
          anchors.centerIn: parent
          Text {
              id: labelText
              font.pixelSize: 18
              text: button.label
              anchors.horizontalCenter: parent.horizontalCenter
          }
          Text {
            id: sublabelText
            font.pixelSize: 12
            text: button.sublabel
            anchors.horizontalCenter: parent.horizontalCenter
          }
        }

        MouseArea {
            id: mouseArea
            property bool hover: false
            anchors.fill: parent
            hoverEnabled: true
            onClicked: button.clicked()
            onEntered: hover = true
            onExited: hover = false
        }

        Rectangle {
            width: parent.height
            height: 8
            visible: pressed
            transformOrigin: Rectangle.Bottom
            anchors.bottom: parent.verticalCenter
            anchors.horizontalCenter: parent.left
            rotation: 90

            gradient: Gradient {
                GradientStop { position: 0; color: Qt.rgba(0,0,0,0) }
                GradientStop { position: 1; color: Qt.rgba(0,0,0,0.2) }
            }
        }
        Rectangle {
            width: parent.height
            height: 8
            visible: pressed
            transformOrigin: Rectangle.Bottom
            anchors.bottom: parent.verticalCenter
            anchors.horizontalCenter: parent.right
            rotation: -90

            gradient: Gradient {
                GradientStop { position: 0; color: Qt.rgba(0,0,0,0) }
                GradientStop { position: 1; color: Qt.rgba(0,0,0,0.2) }
            }
        }
    }

}
