import QtQuick 1.1

Item {
    id: button
    property color color: "lightgrey"
    property alias label: labelText.text
    property alias sublabel: sublabelText.text
    property alias pressed: mouseArea.pressed
    property alias font: labelText.font
    property alias textColor: labelText.color
    property alias enabled: mouseArea.enabled
    property alias radius: rectangle.radius
    property alias border: rectangle.border
    property alias control: guiHint.control
    signal clicked();

    width: 64
    height: 32

    Rectangle {
        id: rectangle
        anchors.fill: parent
        smooth: radius != 0

        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.darker(button.color, pressed ? 1.6 : 1.0 ) }
            GradientStop { position: pressed ? 0.2 : 0.8; color: Qt.darker(button.color, pressed ? 1.4 : 1.2) }
            GradientStop { position: 1.0; color: Qt.darker(button.color, pressed ? 1.2 : 1.4) }
        }

        clip: true

        GuiHint {
          id: guiHint
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.margins: Math.min(8, (parent.height - height) / 2)
        }
        Column {
          anchors.centerIn: parent
          Text {
              id: labelText
              font.pixelSize: 20
              text: button.label
              anchors.horizontalCenter: parent.horizontalCenter
              style: Text.Raised
              styleColor: "#111"
              color: "#ddd"
          }
          Text {
            id: sublabelText
            font.pixelSize: 14
            text: button.sublabel
            anchors.horizontalCenter: parent.horizontalCenter
            style: Text.Raised
            styleColor: "#111"
            color: "#ddd"
          }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: button.clicked()
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

