import QtQuick 1.0

Item {
    id: item_pic
    width: root.width
    height: root.height
    state: "hidden"

    function formatSize(){
        if(pic.height > 510) {
            pic.height = 510;
        }
    }

    /*Component.onCompleted: {
        if(!isCurrentItem) {
            item_pic.state = "hidden"
        } else {
            item_pic.state = ""
        }
    }*/

    Image {
        id: pic
        smooth:  true
        source: filePath
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent

        Image {
            id: shadow_image
            source: "images/shadow.png"
            anchors.top:  parent.bottom
            anchors.topMargin: 30
            width: parent.width
        }

        onStatusChanged: {
            if(pic.status == Image.Ready) {
                timer.start();
                formatSize();
            } else if (pic.status == Image.Loading) {
                timer.stop();
            } else if (pic.status == Image.Error) {
                timer.start();
            }
        }
    }

    states:  [
        State {
            name: "hidden"
            when: !isCurrentItem
            PropertyChanges {
                target: pic
                opacity: 0
            }
        },
        State {
            name: ""
            when: isCurrentItem
            PropertyChanges {
                target: pic
                opacity: 1
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                target:  pic
                duration: 500
                properties: "opacity"
                easing.type: Easing.InOutQuart
            }
        }
    ]
}
