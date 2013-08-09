import Qt 4.7
import Panorama.UI 1.0
import Panorama.Packages 1.0
import Panorama.Settings 1.0
import Panorama.Pandora 1.0
import Panorama.Applications 1.0
import Panorama.SystemInformation 1.0

PanoramaUI {
    id: ui
    name: "Consolidation"
    description: "Console style composite UI for package management and application launching"
    author: "B-ZaR"
    anchors.fill: parent

    // ***************************************
    //                SETTINGS
    // ***************************************

    Setting {
        id: installDevice
        section: "Milky"
        key: "installDevice"
        defaultValue: "/dev/mmcblk1p1"
    }

    Setting {
        id: installDirectory
        section: "Milky"
        key: "installDirectory"
        defaultValue: "menu"
    }

    Setting {
        id: repositoryUrls
        section: "Milky"
        key: "repositoryUrls"
        defaultValue: "http://repo.openpandora.org/client/masterlist?com=true&bzip=true"
    }

    Setting {
        id: customDevices
        section: "Milky"
        key: "customDevices"
        defaultValue: ""
    }

    // Run stuff when the entire UI is loaded
    Timer {
        interval: 1
        running: true
        repeat: false
        onTriggered: {
            ui.milky.crawlDevice();
        }
    }

    Timer {
        interval: 300000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            syncButton.updateEnabled();
        }
    }

    // ***************************************
    //                CONTROLS
    // ***************************************

    Item {
        focus: true
        Keys.forwardTo: [hotKeyHandler, search]
    }

    Item {
        id: hotKeyHandler
        Keys.onPressed: {
            var accept = true;

            if(event.modifiers & Qt.ShiftModifier && event.key === Qt.Key_L) {
                log.visible = true;
            } else if(event.modifiers & Qt.ShiftModifier && event.key === Qt.Key_D) {
                deviceSelection.visible = true;
            } else if(ui.state == "browse") {
                var item = packages.currentItem;
                switch(event.key) {
                    case Qt.Key_Up:    packages.up(); break;
                    case Qt.Key_Down:  packages.down(); break;
                    case Qt.Key_Left:  packages.pageUp(); break;
                    case Qt.Key_Right: packages.pageDown(); break;
                    default: accept = false; break;
                }
            } else if(ui.state == "details") {
                switch(event.key) {
                    case Qt.Key_Return: detailDialog.preview(); break;
                    default:            accept = false; break;
                }
            } else if(ui.state == "applications") {
                switch(event.key) {
                    case Qt.Key_Up:     applications.moveCurrentIndexUp(); break;
                    case Qt.Key_Down:   applications.moveCurrentIndexDown(); break;
                    case Qt.Key_Left:   applications.moveCurrentIndexLeft(); break;
                    case Qt.Key_Right:  applications.moveCurrentIndexRight(); break;
                    case Qt.Key_Return: applications.executeCurrentItem(); break;
                    default: accept = false; break;
                }
            } else {
                accept = false;
            }

            event.accepted = accept;
        }
    }

    Pandora.onPressed: {
        var accept = true;
        if(ui.state == "browse") {
            var item = packages.currentItem;
            switch(event.key) {
                case Pandora.ButtonB:      item.showDetails(); break;
                case Pandora.TriggerL:     modeButton.clicked(); break;
                case Pandora.TriggerR:     ui.setState("categories"); break;
                case Pandora.ButtonStart:  syncButton.clicked(); break;
                case Pandora.ButtonSelect: upgradeAllButton.clicked(); break;
                default:                   accept = false; break;
            }
        } else if(ui.state == "categories") {
            switch(event.key) {
                case Pandora.DPadUp:       categoryListOverlay.categoryList.moveCurrentIndexUp(); break;
                case Pandora.DPadDown:     categoryListOverlay.categoryList.moveCurrentIndexDown(); break;
                case Pandora.DPadLeft:     categoryListOverlay.categoryList.moveCurrentIndexLeft(); break;
                case Pandora.DPadRight:    categoryListOverlay.categoryList.moveCurrentIndexRight(); break;
                case Pandora.ButtonB:      categoryListOverlay.categoryList.currentItem.clicked(); break;
                case Pandora.TriggerL:     modeButton.clicked(); break;
                case Pandora.TriggerR:     categoryFilter.clicked(); break;
                case Pandora.ButtonStart:  syncButton.clicked(); break;
                case Pandora.ButtonSelect: upgradeAllButton.clicked(); break;
                case Pandora.ButtonY:      categoryFilter.nextOrder(); break;
                default:                   accept = false; break;
            }
        } else if(ui.state == "install") {
            switch(event.key) {
                case Pandora.ButtonB: installDialog.yes(); break;
                case Pandora.ButtonX: installDialog.no(); break;
                default: accept = false; break;
            }
        } else if(ui.state == "remove") {
            switch(event.key) {
                case Pandora.ButtonB: removeDialog.yes(); break;
                case Pandora.ButtonX: removeDialog.no(); break;
                default: accept = false; break;
            }
        } else if(ui.state == "upgrade") {
            switch(event.key) {
                case Pandora.ButtonB: upgradeDialog.yes(); break;
                case Pandora.ButtonX: upgradeDialog.no(); break;
                default: accept = false; break;
            }
        } else if(ui.state == "details") {
            switch(event.key) {
                case Pandora.DPadLeft:  detailDialog.previousPreview(); break;
                case Pandora.DPadRight: detailDialog.nextPreview(); break;
                case Pandora.ButtonX:   detailDialog.back(); break;
                case Pandora.ButtonA: detailDialog.remove(); break;
                case Pandora.ButtonY: detailDialog.upgrade(); break;
                case Pandora.ButtonB:
                    if(detailDialog.info.installed)
                        detailDialog.execute();
                    else
                        detailDialog.install();
                    break;
                default: accept = false; break;
            }
        } else if(ui.state == "applications") {
            switch(event.key) {

                case Pandora.ButtonB:      applications.executeCurrentItem(); break;
                case Pandora.ButtonY:      applications.showCurrentItemDetails(); break;
                case Pandora.TriggerL:     modeButton.clicked(); break;
                case Pandora.TriggerR:     ui.setState("categories"); break;
                case Pandora.ButtonStart:  syncButton.clicked(); break;
                case Pandora.ButtonSelect: upgradeAllButton.clicked(); break;
                default:                   accept = false; break;
            }
        }
        event.accepted = accept;
    }

    // ***************************************
    //                  MILKY
    // ***************************************

    property QtObject milky : Milky {
        device: installDevice.value
        targetDir: installDirectory.value

        Component.onCompleted: {
            events.syncStart.connect(function() {
                ui.setState("sync");
            });
            events.syncDone.connect(function() {
                ui.setState("browse");
                syncButton.updateEnabled();
            });

            if(typeof(repositoryUrls.value) === "string" && repositoryUrls.value.length !== 0) {
               milky.addRepository(repositoryUrls.value);
            } else {
                for(var i = 0; i < repositoryUrls.value.length; ++i) {
                    milky.addRepository(repositoryUrls.value[i]);
                }
            }
        }
    }

    // ***************************************
    //                STATES
    // ***************************************

    state: "applications"

    ListModel {
        id: previousStates
    }

    function setState(newState) {
        previousStates.append({name: state});
        state = newState;
    }

    property bool filterChangedApplications: false
    property bool filterChangedBrowse: false

    states: [
        State {
            name: "applications"
            PropertyChanges { target: packagesContainer; visible: false }
            PropertyChanges { target: applicationsContainer; visible: true }
            StateChangeScript { script: { if(filterChangedApplications) applications.updateModel(); filterChangedApplications = false; } }
        },
        State {
            name: "browse"
            PropertyChanges { target: packagesContainer; visible: true }
            PropertyChanges { target: applicationsContainer; visible: false }
            StateChangeScript { script: { if(filterChangedBrowse) packages.updateModel(); filterChangedBrowse = false; } }
        },
        State {
            name: "categories"
            StateChangeScript { script: { filterChangedApplications = true; filterChangedBrowse = true; } }
        }
    ]

    function back() {
        if(previousStates.count > 0) {
            state = previousStates.get(previousStates.count - 1).name;
            previousStates.remove(previousStates.count - 1);
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"

        // ***************************************
        //                OVERLAYS
        // ***************************************

        Rectangle {
            id: syncOverlay
            anchors.fill: parent
            z: 10
            visible: ui.state == "sync"

            // Restrict mouse events to children
            MouseArea { anchors.fill: parent; onPressed: mouse.accepted = true; }

            color: Qt.rgba(0.4,0.4,0.7,0.9)

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Synchronizing database with repository..."
                font.pixelSize: ui.width / 40
            }
        }

        InstallDialog {
            id: installDialog
            visible: active
            anchors.fill: parent
            z: 10
            milky: ui.milky
            installDirectorySetting: installDirectory
            onActivate: ui.setState("install");
            onDeactivate: ui.back();
        }

        RemoveDialog {
            id: removeDialog
            visible: ui.state == "remove"
            anchors.fill: parent
            z: 10
            milky: ui.milky
            onActivate: ui.setState("remove");
            onDeactivate: ui.back();
        }

        UpgradeDialog {
            id: upgradeDialog
            visible: ui.state == "upgrade"
            anchors.fill: parent
            z: 10
            milky: ui.milky
            onActivate: ui.setState("upgrade");
            onDeactivate: ui.back();
        }

        // ***************************************
        //                TOOLBAR
        // ***************************************

        Rectangle {
            id: toolbar
            z: 50
            height: 48
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            color: "#bbb"

            Button {
                id: modeButton
                width: 110
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                label: getLabel()
                controlHint: "L"
                onClicked: {
                    if(ui.state == "applications") {
                        ui.setState("browse");
                    } else {
                        ui.setState("applications");
                    }
                }

                function getLabel() {
                    if(ui.state === "applications") {
                        return "Install";
                    } else if(ui.state === "browse") {
                        return "Launch";
                    } else {
                        for(var i = previousStates.count - 1; i >= 0; --i) {
                            if(previousStates.get(i).name === "applications") {
                                return "Install";
                            } else if(previousStates.get(i).name === "browse") {
                                return "Launch";
                            }
                        }
                        return "-";
                    }
                }

            }
            Button {
                id: categoryFilter
                property string value: ""

                property int selectedOrder: 0
                property variant orderOptions: [
                    {title:"Alphabetical", value:"title", ascending: true, sectionProperty: "", sectionCriteria: -1},
                    {title:"Newest", value:"modified", ascending: false, sectionProperty: "lastUpdatedString", sectionCriteria: ViewSection.FullString}
                ]

                property string orderTitle: orderOptions[selectedOrder].title
                property string orderProperty: orderOptions[selectedOrder].value
                property bool orderAscending: orderOptions[selectedOrder].ascending
                property string sectionProperty: orderOptions[selectedOrder].sectionProperty
                property int sectionCriteria: orderOptions[selectedOrder].sectionCriteria

                function nextOrder() {
                    selectedOrder = (selectedOrder + 1) % orderOptions.length;
                }

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: modeButton.right
                anchors.right: upgradeAllButton.left
                anchors.leftMargin: 2
                anchors.rightMargin: 2

                label: (categoryFilter.value ? categoryFilter.value : "All") + ", " + orderTitle
                controlHint: "R"
                onClicked: {
                    if(ui.state != "categories") {
                        ui.setState("categories");
                    } else {
                        ui.back();
                    }
                }
            }

            Button {
                id: upgradeAllButton
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: syncButton.left
                anchors.rightMargin: 2
                width: 160
                color: enabled ? "#ddf" : "#888"
                enabled: milky.hasUpgrades
                label: enabled ? "Upgrade all" : "No upgrades"
                controlHint: enabled ? "Sl" : ""
                onClicked: if(enabled) upgradeDialog.upgradeAll();
            }

            Button {
                id: syncButton
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: 160
                color: enabled ? "#bbf" : "#888"
                label: enabled ? "Synchronize" : "Up to date"
                controlHint: enabled ? "St" : ""
                onClicked: if(enabled) ui.milky.syncWithRepository();

                function updateEnabled() {
                    var updated = ui.milky.repositoryUpdated();
                    var lastSynced = 0;
                    var repositories = ui.milky.repositories;
                    for(var i = 0; i < repositories.length; ++i) {
                        var timestamp = new Date(repositories[i].timestamp).getTime();
                        lastSynced = lastSynced > timestamp ? lastSynced : timestamp;
                    }

                    var neverSynced = lastSynced == 0;
                    enabled = updated || neverSynced;
                }
            }
        }

        Rectangle {
            id: topSeparator
            z: 50
            height: 4
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: toolbar.bottom
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#888" }
                GradientStop { position: 1.0; color: "#666" }
            }

        }

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: topSeparator.bottom
            anchors.bottom: searchBox.top

            // ***************************************
            //             APPLICATIONS
            // ***************************************

            Rectangle {
                id: applicationsContainer
                anchors.fill: parent

                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#555" }
                    GradientStop { position: 1.0; color: "#333" }
                }

                PreloadedGridView {
                    id: applications
                    anchors.fill: parent

                    property int rowSize: 8
                    property real spacing: 8

                    property int textSize: 12
                    property int iconSize: Math.floor((cellHeight - textSize) / 16) * 16

                    function updateModel() {
                        model = filteredModel();
                    }

                    function filteredModel() {
                        var result = Applications.list;

                        if(categoryFilter.value)
                            result = result.inCategory(categoryFilter.value)

                        if(search.text)
                            result = result.containing("name", search.text)

                        return result.sortedBy("name", true);
                    }

                    function executeCurrentItem() {
                        console.log(applications.currentItem.ident)
                        Applications.execute(applications.currentItem.ident);
                    }

                    function showCurrentItemDetails() {
                        if(applications.currentItem.pndId) {
                            detailDialog.pndId = applications.currentItem.pndId;
                            detailDialog.application = applications.currentItem;
                            ui.setState("details");
                        }
                    }

                    model: []

                    Component.onCompleted: updateModel();

                    cellWidth: width / rowSize
                    cellHeight: cellWidth

                    highlight: Rectangle {
                        x: applications.currentItem.x
                        y: applications.currentItem.y
                        color: "#888"
                        radius: width/8
                        width: applications.cellWidth
                        height: applications.cellWidth
                    }

                    delegate: Item {
                        property string ident: identifier
                        property string pndId: pandoraId
                        property string version: version
                        property string description: comment
                        width: applications.cellWidth
                        height: applications.cellHeight
                        Item {
                            anchors.fill: parent
                            anchors.margins: applications.spacing / 2

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    applications.currentIndex = index;
                                }
                                onDoubleClicked: {
                                    applications.executeCurrentItem();
                                }
                            }
                            Image {
                                id: iconField
                                source: icon ? icon : "images/application-x-executable.png"
                                height: applications.iconSize
                                width: applications.iconSize
                                sourceSize.width: applications.iconSize
                                asynchronous: true
                                smooth: false
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                id: nameLabel

                                width: parent.width

                                text: name
                                font.pixelSize: applications.textSize
                                font.bold: true
                                style: Text.Outline; styleColor: "#222"
                                color: "#ddd"

                                anchors.fill: parent
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignBottom
                            }
                        }
                    }
                }
            }

            // ***************************************
            //                PACKAGES
            // ***************************************


            Rectangle {
                id: packagesContainer
                anchors.fill: parent
                color: "#eee"
                visible: false

                ListView {
                    id: packages
                    anchors.fill: parent
                    currentIndex: 0

                    function up() {
                        decrementCurrentIndex();
                        positionViewAtIndex(currentIndex, ListView.Contain);
                    }
                    function down() {
                        incrementCurrentIndex();
                        positionViewAtIndex(currentIndex, ListView.Contain);
                    }
                    function pageUp() {
                        gotoIndex(currentIndex < 10 ? 0 : currentIndex - 10, ListView.Beginning);
                    }
                    function pageDown() {
                        if(model.numResults === undefined)
                            return;
                        gotoIndex(currentIndex + 10 < model.numResults() ? currentIndex + 10 : model.numResults() - 1, ListView.Beginning);
                    }

                    function updateModel() {
                        model = filteredModel();
                    }

                    function filteredModel() {
                        var result = ui.milky.matching("installed", false);

                        if(categoryFilter.value)
                            result = result.inCategory(categoryFilter.value)

                        if(search.text)
                            result = result.containing("title", search.text)

                        return result.sortedBy(categoryFilter.orderProperty, categoryFilter.orderAscending).sortedBy("hasUpdate", false);
                    }

                    model: []

                    Component.onCompleted: updateModel();

                    cacheBuffer: 2 * height

                    highlightFollowsCurrentItem: false
                    highlight: Rectangle {
                        z: 10
                        y: packages.currentItem.y
                        height: 32
                        width: packages.currentItem.width
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(0.8,0.6,0.8,0.1) }
                            GradientStop { position: 0.7; color: Qt.rgba(0.8,0.6,0.8,0.3) }
                            GradientStop { position: 1.0; color: Qt.rgba(0.8,0.6,0.8,0.8) }
                        }
                    }

                    delegate: PackageDelegate {
                        onShowDetails: {
                            detailDialog.pndId = identifier;
                            packages.currentIndex = index;
                            ui.setState("details");
                        }
                    }


                    section.property: categoryFilter.sectionProperty
                    section.criteria: categoryFilter.sectionCriteria
                    section.delegate: Rectangle {
                        height: 32
                        width: packages.width
                        z: 10
                        color: "#555"

                        Text {
                            anchors.leftMargin: 16
                            anchors.fill: parent
                            text: section
                            font.pixelSize: 24
                            color: "#eee"
                        }
                    }

                    function gotoIndex(idx, mode) {
                        packages.positionViewAtIndex(idx, mode);
                        currentIndex = idx;
                    }
                }
            }

            FilterDialog {
                id: categoryListOverlay
                z: 10
                anchors.fill: parent
                visible: ui.state == "categories"
                categoryFilter: categoryFilter
                model: ui.milky.categories
            }


            PackageDetails {
                z: 10
                id: detailDialog
                anchors.fill: parent
                visible: ui.state == "details"
                milky: ui.milky

                onInstall: {
                    if(pndId && !pnd.installed)
                        installDialog.install(pnd.id, pnd.title);
                }
                onRemove: {
                    if(pndId && pnd.installed)
                        removeDialog.remove(pnd.id, pnd.title);
                }
                onUpgrade: {
                    if(pndId && pnd.hasUpdate)
                        upgradeDialog.upgrade(pnd.id, pnd.title);
                }
                onDeactivate: {
                    ui.back();
                }
                onExecute: {
                    Applications.execute(application.ident);
                }
            }
        }
        // ***************************************
        //             ACTION QUEUE
        // ***************************************
        Rectangle {
            id: actionQueueResizeHandle
            width: 64
            height: 64
            anchors.verticalCenter: parent.verticalCenter
            radius: 32
            color: Qt.rgba(0.1, 0.1, 0.1, hidden ? 0.5 : 0.9)

            property int minWidth: 64
            property int maxWidth: 256
            property int xMin: parent.width - maxWidth - width/2
            property int xMax: parent.width - minWidth - width/2
            property int xHidden: parent.width - width/2

            property bool hidden: true
            property bool large: true

            z: 50
            x: xHidden

            MouseArea {
                anchors.fill: parent
                drag {
                    target: actionQueueResizeHandle
                    axis: Drag.XAxis
                    minimumX: parent.xMin
                    maximumX: parent.xHidden
                    filterChildren: true
                }
                onReleased: {
                    actionQueueResizeHandleAnimation.stop();
                    actionQueueResizeHandleAnimation.from = drag.target.x;
                    if(drag.target.x < (drag.target.xMin + drag.target.xMax)/2) {
                        actionQueueResizeHandleAnimation.to = parent.xMin;
                        drag.target.large = true;
                        drag.target.hidden = false;
                    } else if(drag.target.x < (drag.target.xMax + drag.target.xHidden)/2) {
                        actionQueueResizeHandleAnimation.to = parent.xMax;
                        drag.target.large = false;
                        drag.target.hidden = false;
                    } else {
                        actionQueueResizeHandleAnimation.to = drag.target.xHidden;
                        drag.target.hidden = true;
                    }

                    actionQueueResizeHandleAnimation.start();
                }
            }

            PropertyAnimation {
                id: actionQueueResizeHandleAnimation
                target: actionQueueResizeHandle
                property: "x"
                duration: 200
            }

        }

        Rectangle {
            id: actionQueueContainer

            z: 51

            anchors.top: topSeparator.bottom
            anchors.bottom: searchBox.top
            anchors.left: actionQueueResizeHandle.horizontalCenter
            anchors.right: parent.right

            clip: true

            color: Qt.rgba(0.1, 0.1, 0.1, 0.9)

            ActionQueue {
                id: actionQueue
                anchors.fill: parent
                milky: ui.milky

                onItemAdded: {
                    if(actionQueueContainer.hidden) {
                        actionQueueResizeHandleAnimation.stop();
                        actionQueueResizeHandle.hidden = false;
                        actionQueueResizeHandleAnimation.from = actionQueueContainer.xHidden;
                        if(actionQueueResizeHandle.large) {
                            actionQueueResizeHandleAnimation.to = actionQueueContainer.xMin;
                        } else {
                            actionQueueResizeHandleAnimation.to = actionQueueContainer.xMax;
                        }
                        actionQueueResizeHandleAnimation.start();
                    }
                }

                onLastItemRemoved: {
                    actionQueueResizeHandleAnimation.stop();
                    actionQueueResizeHandle.hidden = true;
                    actionQueueResizeHandleAnimation.from = actionQueueContainer.x;
                    actionQueueResizeHandleAnimation.to = actionQueueContainer.xHidden;
                    actionQueueResizeHandleAnimation.start();
                }
            }
        }

        // ***************************************
        //                SEARCH
        // ***************************************

        Rectangle {
            id: searchBox
            z: 50
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: bottomSeparator.top
            height: search.text != "" ? 32 : 0
            color: "#fff"
            border.width: 2
            border.color: "#111"

            TextInput {
                id: search
                anchors.fill: parent
                anchors.leftMargin: 4
                font.pixelSize: 24
                onTextChanged: {
                    if(ui.state == "applications") {
                        applications.updateModel()
                    } else if(ui.state == "browse") {
                        packages.updateModel()
                    }
                }
            }
        }

        // ***************************************
        //                STATUS
        // ***************************************

        Rectangle {
            id: bottomSeparator
            z: 50
            height: 4
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: statusContainer.top
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#fff" }
                GradientStop { position: 1.0; color: "#ddd" }
            }

        }

        Rectangle {
            id: statusContainer

            z: 50
            height: 20
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#ddd" }
                GradientStop { position: 0.8; color: "#ccc" }
                GradientStop { position: 1.0; color: "#aaa" }
            }

            Clock {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color: "#222"
                textSize: 18
            }

            Text {
                text: SystemInformation.battery + "%"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                color: "#222"
                font.pixelSize: 18
            }
        }

        Rectangle {
            id: deviceSelection
            property variant deviceOptions: ui.milky.getDeviceList()
            anchors.centerIn: parent
            visible: false
            height: childrenRect.height
            width: parent.width/2
            color: "gray"
            z: 1024

            Text {
                id: noDevicesFound
                text: "No devices found"
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
                visible: deviceListRepeater.count == 0
            }
            Column {
                width: childrenRect.width
                height: childrenRect.height
                Repeater {
                    function getDevices() {
                        var list = []
                        if(typeof(customDevices.value) == "string" && customDevices.value.length != 0) {
                            list.push({mountPoint: customDevices.value});
                        } else {
                            for(var i = 0; i < customDevices.value.length; ++i) {
                                list.push({mountPoint: customDevices.value[i]});
                            }
                        }

                        for(var i = 0; i < deviceSelection.deviceOptions.length; ++i) {
                            if(!/\/mnt\/(utmp|pnd)\/.*/.test(deviceSelection.deviceOptions[i].mountPoint))
                                list.push(deviceSelection.deviceOptions[i])
                        }
                        return list;
                    }

                    id: deviceListRepeater
                    model: getDevices()


                    delegate: Button {
                        property string mountPoint: modelData.mountPoint
                        height: 32
                        width: deviceSelection.width
                        color: "#ccc"
                        label: mountPoint
                        onClicked: {
                            installDevice.value = mountPoint;
                            ui.milky.applyConfiguration();
                            deviceSelection.visible = false;
                            ui.milky.crawlDevice();
                            syncButton.updateEnabled();
                        }
                    }
                }
            }
        }

        Rectangle {
            id: log
            visible: false
            anchors.fill: parent
            anchors.margins: 32
            z: 1024
            color: Qt.rgba(0.9, 0.9, 0.9, 0.9)
            radius: 8
            border {
                color: "#111"
                width: 1
            }

            ListView {
                id: statusMessageView
                clip: true
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: closeLogButton.top
                anchors.margins: 4
                highlightFollowsCurrentItem: true

                model: ListModel {
                    id: statusMessages
                    ListElement {
                        message: "Welcome to MilkyTest!"
                    }
                }
                delegate: Text {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    text: "" + message
                }
            }

            Button {
                id: closeLogButton
                label: "Close"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                radius: 8
                anchors.leftMargin: 1
                onClicked: log.visible = false
            }
        }

        function handleMessage(messageType, messageData) {
            var messages = {}

            messages[MilkyEvents.Installing] = "Installing PND (id=" + messageData + ")";
            messages[MilkyEvents.Removing] = "Removing PND (id=" + messageData + ")";
            messages[MilkyEvents.Upgrading] = "Upgrading PND (id=" + messageData + ")";
            messages[MilkyEvents.InvalidConfiguration] = "ERROR: Invalid configuration";
            messages[MilkyEvents.InvalidDevice] = "ERROR: Invalid device " + messageData;
            messages[MilkyEvents.DeviceNotMounted] = "ERROR: Device "  + messageData + " not mounted";
            messages[MilkyEvents.InvalidJSON] = "ERROR: Invalid JSON (" + messageData + ")";
            messages[MilkyEvents.HTTPError] = "ERROR: HTTP error (" + messageData + ")";
            messages[MilkyEvents.FileCreationError] = "ERROR: Error creating file";
            messages[MilkyEvents.FileCopyError] = "ERROR: Error copying file";
            messages[MilkyEvents.PNDNotFound] = "ERROR: PND not found (id=" + messageData + ")";
            messages[MilkyEvents.PNDNotInstalled] = "ERROR: PND not installed (id=" + messageData + ")";
            messages[MilkyEvents.PNDAlreadyInstalled] = "ERROR: PND already installed (id=" + messageData + ")";
            messages[MilkyEvents.PNDSkippingAlreadyInstalled] = "Skipping already installed PND (id=" + messageData + ")";
            messages[MilkyEvents.PNDReinstalling] = "Reinstalling PND (id=" + messageData + ")";
            messages[MilkyEvents.PNDAlreadyUpdated] = "ERROR: Already updated (id=" + messageData + ")";
            messages[MilkyEvents.PNDRemoveFailed] = "ERROR: Removing PND failed (id=" + messageData + ")";
            messages[MilkyEvents.PNDUpgradeFailed] = "ERROR: Upgrading PND failed (id=" + messageData + ")";
            messages[MilkyEvents.PNDInstallFailed] = "ERROR: Installing PND failed (id=" + messageData + ")";
            messages[MilkyEvents.PNDHasUpdate] = "PND has update (id=" + messageData + ")";
            messages[MilkyEvents.PNDFound] = "PND found (id=" + messageData + ")";
            messages[MilkyEvents.NoTargets] = "ERROR: No targets";
            messages[MilkyEvents.NoDatabase] = "No database, creating a new one";
            messages[MilkyEvents.NoUpdates] = "No updates";
            messages[MilkyEvents.MD5CheckFailed] = "ERROR: Invalid MD5 checksum";
            messages[MilkyEvents.MD5CheckFailedForce] = "ERROR: Invalid MD5 checksum, forcing";

            statusMessages.append({"message": messages[messageType]});
        }

        function createAddStatusMessageFunction(message) {
            var f = function() {
                statusMessages.append({"message": message});
                status.contentY = status.contentHeight;
            }

            return f;
        }

        Component.onCompleted: {
            ui.milky.events.message.connect(handleMessage);
            ui.milky.events.fetchStart.connect(createAddStatusMessageFunction("Fetching..."));
            ui.milky.events.fetchDone.connect(createAddStatusMessageFunction("Fetch complete."));
            ui.milky.events.syncStart.connect(createAddStatusMessageFunction("Syncing..."));
            ui.milky.events.syncDone.connect(createAddStatusMessageFunction("Sync complete."));
            ui.milky.events.saveStart.connect(createAddStatusMessageFunction("Saving..."));
            ui.milky.events.saveDone.connect(createAddStatusMessageFunction("Save complete."));
            ui.milky.events.creatingBackup.connect(createAddStatusMessageFunction("Creating backup..."));
            ui.milky.events.restoringBackup.connect(createAddStatusMessageFunction("Restoring backup..."));
            ui.milky.events.upgradeStart.connect(createAddStatusMessageFunction("Upgrading..."));
            ui.milky.events.upgradeDone.connect(createAddStatusMessageFunction("Upgrade complete."));
            ui.milky.events.upgradeCheck.connect(createAddStatusMessageFunction("Upgrade check."));
            ui.milky.events.removeStart.connect(createAddStatusMessageFunction("Removing..."));
            ui.milky.events.removeDone.connect(createAddStatusMessageFunction("Remove complete."));
            ui.milky.events.removeCheck.connect(createAddStatusMessageFunction("Remove check."));
            ui.milky.events.installStart.connect(createAddStatusMessageFunction("Installing..."));
            ui.milky.events.installDone.connect(createAddStatusMessageFunction("Install complete."));
            ui.milky.events.installCheck.connect(createAddStatusMessageFunction("Install check."));
            ui.milky.events.crawlStart.connect(createAddStatusMessageFunction("Crawling..."));
            ui.milky.events.crawlDone.connect(createAddStatusMessageFunction("Crawl complete."));
            ui.milky.events.cleanStart.connect(createAddStatusMessageFunction("Cleaning..."));
            ui.milky.events.cleanDone.connect(createAddStatusMessageFunction("Clean complete."));
            ui.milky.events.downloadStarted.connect(createAddStatusMessageFunction("Download started."));
            ui.milky.events.downloadFinished.connect(createAddStatusMessageFunction("Download finished."));
            ui.milky.events.checkingMD5.connect(createAddStatusMessageFunction("Checking MD5..."));
            ui.milky.events.parsingFilename.connect(createAddStatusMessageFunction("Parsing filename..."));
            ui.milky.events.copyingFile.connect(createAddStatusMessageFunction("Copying file..."));
        }
    }

    Rectangle {
        id: developmentVersionNotification
        color: "#111"
        anchors.fill: parent
        z: 2048

        MouseArea {
            anchors.fill: parent
            onClicked: parent.visible = false
        }

        Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 24
            font.pixelSize: 20
            wrapMode: Text.WordWrap
            color: "#eee"
            text: "This is a development snapshot of Consolidation UI. It may not reflect the final version, and some functionality may be missing, erratic, illogical, dangerous or very (very!) slow. You are using this UI at your own risk to get a glimpse of the current state of Panorama and Consolidation UI and should not use it for anything important. Clear?"
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:parent.bottom
            font.pixelSize: 24
            anchors.margins: 24
            color: "#fff"
            text: "Click to proceed, press F12 to quit"
        }
    }
}
