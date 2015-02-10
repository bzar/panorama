import QtQuick 1.1
View {
  id: view
  viewTitle: "Settings"

  Component {
    id: booleanDelegate
    BooleanSetting {
      id: booleanSetting
      function toggleIfActive() {
        if(booleanSetting.activeFocus) {
          booleanSetting.toggle();
        }
      }
      Keys.onRightPressed: toggleIfActive()
      Keys.onReturnPressed: toggleIfActive()

      Connections {
        target: view
        onOkButton: toggleIfActive()
      }

      setting: componentSetting
      focus: true
      width: 32
      height: 32
    }
  }
  Component {
    id: textDelegate
    TextSetting {
      focus: true
      setting: componentSetting
      width: settings.width / 2
      height: 32
    }
  }

  ListView {
    id: settings
    anchors.fill: parent
    anchors.margins: 8
    spacing: 8
    focus: true

    model: [
      {type: "boolean", setting: flipBX, title: "Alternate OK/Back"},
      {type: "text", setting: usernameSetting, title: "Repo username"},
      {type: "text", setting: apiKeySetting, title: "Repo API key"}
    ]
    delegate: FocusScope {
      height: 32
      width: parent.width
      Row {
        anchors.fill: parent
        Text {
          text: modelData.title
          font.pixelSize: 24
          width: parent.width / 2
        }

        Loader {
          function getDelegate() {
            if(modelData.type === "boolean") {
              return booleanDelegate;
            } else if(modelData.type === "text") {
              return textDelegate;
            }

            return undefined;
          }

          property QtObject componentSetting: modelData.setting
          focus: true
          sourceComponent: getDelegate()
        }
      }
    }
    highlightFollowsCurrentItem: true
    highlight: Rectangle {
      color: "#ddd"
      width: settings.width
      height: 32
    }
  }
}

