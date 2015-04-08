import QtQuick 1.1
import "theme.js" as Theme

View {
  id: view
  viewTitle: "PNDManager " + pndManager.versionString
  signal exit()

  Image {
    anchors.fill: parent
    fillMode: Image.Tile
    source: "img/settings_background.png"
  }

  Flickable {
    id: settings
    contentHeight: settingsContent.height
    anchors.fill: parent
    anchors.topMargin: 0
    anchors.bottomMargin: 16
    anchors.leftMargin: 24
    anchors.rightMargin: 24

    function ensureVisible(item) {
      var absy = item.y + settingsColumn.y;

      if(absy + item.height > contentY + height) {
        contentY = absy + item.height - height;
      } else if(absy < contentY) {
        contentY = absy;
      }
    }
    Item {
      id: settingsContent
      anchors.left: parent.left
      anchors.right: parent.right
      height: childrenRect.height
      Item {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100
        Row {
          anchors.centerIn: parent
          spacing: 24
          Image {
            id: settingsLogo
            source: "img/settings_gear.png"
          }
          Text {
            text: "Settings"
            font.pixelSize: settingsLogo.height * 0.80
            color: "#e4e4e4"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
            font.letterSpacing: 4
          }
        }
      }


      Rectangle {
        id: separator
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        color: Qt.rgba(0.87,0.87,0.87,0.11)
        height: 1
      }
      Column {
        id: settingsColumn
        spacing: 16
        anchors.top: separator.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 32
        anchors.rightMargin: 16

        SettingsItem {
          id: flipBXSetting
          title: "Menu navigation:"
          focus: true
          anchors.left: parent.left
          anchors.right: parent.right
          KeyNavigation.down: mouseCursorVisibleSetting
          onFocusChanged: if(focus) settings.ensureVisible(flipBXSetting)
          BooleanSetting {
            swap: true
            anchors.left: parent.left
            anchors.right: parent.right
            Keys.onRightPressed: toggleIfActive()
            Keys.onLeftPressed: toggleIfActive()
            Keys.onReturnPressed: toggleIfActive()
            Connections { target: view; onOkButton: toggleIfActive() }
            setting: flipBX
            enabledText: "(B) Return\n(X) Confirm"
            disabledText: "(B) Confirm\n(X) Return"
            focus: true
          }
        }
        SettingsItem {
          id: mouseCursorVisibleSetting
          title: "Mouse cursor:"
          anchors.left: parent.left
          anchors.right: parent.right
          KeyNavigation.up: flipBXSetting
          KeyNavigation.down: showSplashScreenSetting
          onFocusChanged: if(focus) settings.ensureVisible(mouseCursorVisibleSetting)
          BooleanSetting {
            anchors.left: parent.left
            anchors.right: parent.right
            Keys.onRightPressed: toggleIfActive()
            Keys.onLeftPressed: toggleIfActive()
            Keys.onReturnPressed: toggleIfActive()
            Connections { target: view; onOkButton: toggleIfActive() }
            setting: mouseCursorVisible
            enabledText: "Enabled"
            disabledText: "Disabled"
            focus: true
          }
        }
        SettingsItem {
          id: showSplashScreenSetting
          title: "Welcome screen:"
          anchors.left: parent.left
          anchors.right: parent.right
          KeyNavigation.up: mouseCursorVisibleSetting
          KeyNavigation.down: showHintsSetting
          onFocusChanged: if(focus) settings.ensureVisible(showSplashScreenSetting)
          BooleanSetting {
            anchors.left: parent.left
            anchors.right: parent.right
            Keys.onRightPressed: toggleIfActive()
            Keys.onLeftPressed: toggleIfActive()
            Keys.onReturnPressed: toggleIfActive()
            Connections { target: view; onOkButton: toggleIfActive() }
            setting: showSplashScreen
            enabledText: "Show at startup"
            disabledText: "Disabled"
            focus: true
          }
        }
        SettingsItem {
          id: showHintsSetting
          image: "img/guihints_banner.png"
          anchors.left: parent.left
          anchors.right: parent.right
          KeyNavigation.up: showSplashScreenSetting
          KeyNavigation.down: usernameSettingSetting
          onFocusChanged: if(focus) settings.ensureVisible(showHintsSetting)
          BooleanSetting {
            anchors.left: parent.left
            anchors.right: parent.right
            Keys.onRightPressed: toggleIfActive()
            Keys.onLeftPressed: toggleIfActive()
            Keys.onReturnPressed: toggleIfActive()
            Connections { target: view; onOkButton: toggleIfActive() }
            setting: showHints
            enabledText: "Enabled"
            disabledText: "Disabled"
            focus: true
          }
        }

        Item {
          height: 12
          anchors.left: parent.left
          anchors.right: parent.right
        }

        Column {
          anchors.left: parent.left
          anchors.right: parent.right
          spacing: 8
          Rectangle {
            id: banner
            color: Qt.rgba(0,0,0,0.7)
            height: 48
            width: parent.width

            Text {
              text: "Enabling rating and commenting"
              color: Qt.rgba(1,1,1,0.88)
              font.pixelSize: 32
              font.letterSpacing: 2
              anchors.verticalCenter: parent.verticalCenter
              anchors.left: parent.left
              anchors.leftMargin: 54
            }
          }
          Text {
            text: "1. Log into repo.openpandora.org, open the \"My account\" page and from there \"Account details\". Have an API key generated."
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 43
            wrapMode: Text.WordWrap
            font.pixelSize: 20
            font.letterSpacing: 2
            color: "#eee"
            font.italic: true
          }
          Text {
            text: "2. Enter your repo.openpandora.org user name and the API key (NOT your password) below."
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 43
            wrapMode: Text.WordWrap
            font.pixelSize: 20
            font.letterSpacing: 2
            color: "#eee"
            font.italic: true
            height: paintedHeight + 12
          }
        }
        SettingsItem {
          id: usernameSettingSetting
          title: "Username:"
          anchors.left: parent.left
          anchors.right: parent.right
          KeyNavigation.up: showHintsSetting
          KeyNavigation.down: apiKeySettingSetting
          onFocusChanged: if(focus) settings.ensureVisible(usernameSettingSetting)
          TextSetting {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 32
            setting: usernameSetting
            focus: true
          }
        }
        SettingsItem {
          id: apiKeySettingSetting
          title: "API key (NOT password!):"
          anchors.left: parent.left
          anchors.right: parent.right
          KeyNavigation.up: usernameSettingSetting
          onFocusChanged: if(focus) settings.ensureVisible(exitButton)
          TextSetting {
            anchors.left: parent.left
            anchors.right: parent.right
            height: 32
            setting: apiKeySetting
            focus: true
          }
        }
        Item {
          id: exitButton
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.rightMargin: -32
          height: childrenRect.height + 16
          Button {
            label: "Exit settings"
            height: 64
            width: 256
            radius: 4
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 16
            onClicked: exit()
            color: Theme.colors.yes
            control: "keyboardfnlayer-f9"
          }
        }
      }
    }
  }
}
