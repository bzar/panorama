//root.qml - The QML file that is responsible for containing PandoraUI instances
import QtQuick 2.0
import Panorama.UI 1.0
import Panorama.Settings 1.0

Item {
    Setting {
        id: fullscreen
        section: "panorama"
        key: "fullscreen"
        defaultValue: false
        onValueChanged: runtime.setFullscreen(value)
    }
    Component.onCompleted: runtime.setFullscreen(fullscreen.value)

    Keys.onPressed: {
        if((event.key == Qt.Key_F && event.modifiers & Qt.ControlModifier) || event.key == Qt.Key_F11) {
            event.accepted = true;
            fullscreen.value = !fullscreen.value;
        } else if((event.key == Qt.Key_Q && event.modifiers & Qt.ControlModifier) || event.key == Qt.Key_F12) {
            event.accepted = true;
            Qt.quit();
        }
    }

    Loader {
        id: uiLoader
        anchors.fill: parent
        focus: true //XXX does this cause issues?
        source: "file://" + uiPath + "/ui.qml"
        onLoaded: {
            print("Loaded UI " + item.name + " created by " + item.author + ".");
            print("Description:");
            print(item.description);
        }
    }
}
