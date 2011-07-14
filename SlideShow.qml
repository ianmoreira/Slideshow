import QtQuick 1.0
import Qt.labs.folderlistmodel 1.0


Rectangle {
    id: root
    width: 1280
    height: 720
    color:  "black"

    property int controler: 0

    FolderListModel {
        id: folderModel
        folder: "data"
        sortField: "Time"
        nameFilters: ["*.jpg", "*.png", "*.jpeg", "*.gif", "*.mp4", "*.mov", "*.flv", "*.avi"]
    }

    Image {
        id: bg
        source: "images/background.png"
    }

    Component {
        id: fileDelegate
        Item {
            id: element
            width: root.width
            height: root.height

            property bool video: true
            property int actualItem: controler

            function findType(value) {
                var index = value.indexOf(".");
                var type = value.slice(index+1, value.length);

                if (type == "mp4" || type == "mov" || type == "flv" || type == "avi") {
                    video = true;
                } else {
                    video = false;
                }

            }

            Loader {
                property bool isCurrentItem: controler == index
                source: {
                    if(video)
                        return "ItemVideo.qml"
                    else
                        return "ItemPicture.qml"

                }
            }

            onActualItemChanged: {
                findType(fileName)
            }

            Component.onCompleted: {
                findType(fileName)
            }
        }
    }

    ListView {
        id: listView
        anchors.fill:  parent
        currentIndex:controler
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        highlightMoveSpeed: 1500
        highlightRangeMode: ListView.StrictlyEnforceRange
        model: folderModel
        delegate: fileDelegate
    }

    Timer {
        id: timer
        interval: 7000
        running: true
        repeat: true
        onTriggered: {
            controler++
            if(controler > listView.count) {
                listView.highlightMoveSpeed = -1;
                controler = 0;
            }
        }
    }
}
