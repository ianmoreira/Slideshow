import QtQuick 1.0
import Qt.labs.folderlistmodel 1.0


Rectangle {
    id: root
    width: 1280
    height: 720
    color:  "black"

    property int controler: 0

    function scaleProportion(big1, small1, big2, small2, value)
    {
        var bigValueOne = big1
        var smallValueOne = small1

        var bigValueTwo = big2
        var smallValueTwo = small2

        return ((bigValueTwo - smallValueTwo) / (bigValueOne - smallValueOne)) * (value - smallValueOne) + smallValueTwo
    }

    FolderListModel {
        id: folderModel
        folder: "data"
        sortField: "Time"
        nameFilters: ["*.jpg", "*.png", "*.jpeg", "*.gif", "*.url"]
    }

    Image {
        id: bg
        anchors.fill: parent
        fillMode: Image.Stretch
        source: "images/background.png"
    }

    Component {
        id: fileDelegate
        Item {
            id: element
            width: root.width
            height: root.height

            property int locationTracker: x - listView.contentX
            property bool video
            property int actualItem: controler

            function findType(value) {
                var index = value.indexOf(".");
                var type = value.slice(index+1, value.length);

                if (type == "url") {
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

            transform: Rotation {
                id: itemRotation
                origin.x: element.width/2
                origin.y: element.height/2
                axis { x: 0.5; y: 1; z: 0 }
                angle: scaleProportion(root.width, -root.width, -100, 100, locationTracker)
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
        spacing:  -root.width/3
        anchors.fill:  parent
        currentIndex:controler
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem
        interactive: false
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
            if(controler > listView.count-1) {
                controler = 0;
            }
        }
    }
}
