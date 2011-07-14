import QtQuick 1.0
import QtMultimediaKit 1.1

Item {
    width: root.width
    height: root.height

    Component.onCompleted: {
        if(!isCurrentItem)
            videoComp.stop();
        else
            videoComp.play();

        if(videoComp.height > 510) {
            var proportion = 510 / videoComp.height
            videoComp.scale = proportion;
        } else {
            videoComp.scale = 1;
        }
    }

    Video {
        id: videoComp
        source: filePath
        anchors.centerIn: parent
        volume:  0.0

        Image {
            id: shadow_video
            source: "images/shadow.png"
            anchors.top:  parent.bottom
            anchors.topMargin: 30
            width: parent.width
        }

        onStatusChanged: {
            if(videoComp.status == Video.NoMedia || videoComp.status == Video.InvalidMedia) {
                timer.start();
                controler++
            } else if (videoComp.status == Video.Loading || videoComp.status == Video.Loaded) {
                timer.stop();
            } else if (videoComp.status == Video.EndOfMedia) {
                controler++
                timer.start();
            }
        }
    }
}
