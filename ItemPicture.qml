import QtQuick 1.0

Item {
    width: root.width
    height: root.height

    function formatSize(){
        if(pic.height > 510) {
            var proportion = 510 / pic.height
            pic.scale = proportion;
        } else {
            pic.scale = 1;
        }
    }

    Image {
        id: pic
        smooth:  true
        source: filePath
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


}
