import QtQuick 1.0
import QtMultimediaKit 1.1

Item {
    id: item_video
    width: root.width
    height: root.height

    property string videoSource

    Component.onCompleted: {
        parseUrl(filePath)

        if(!isCurrentItem) {
            videoComp.stop();
            loading.playing = false;
        }
    }

    function formatSize(){
        if(videoComp.height > 510) {
            var proportion = 510 / videoComp.height
            videoComp.scale = proportion;
        } else {
            videoComp.scale = 1;
        }
    }

    function parseUrl(value)
    {
        var url_xhr = new XMLHttpRequest();
        url_xhr.onreadystatechange = function() {
            if (url_xhr.readyState == XMLHttpRequest.DONE) {
                videoSource = url_xhr.responseText;
            }
        }

        url_xhr.open("GET", value);
        url_xhr.send();
    }

    Loading {
        id: loading
        anchors.centerIn: parent
    }

    Video {
        id: videoComp
        source: videoSource
        anchors.centerIn: parent
        volume:  0.5

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
            } else if (videoComp.status == Video.Loading) {
                loading.playing = true;
                timer.stop();
            } else if (videoComp.status == Video.Loaded){
                loading.playing = false;
                formatSize();
                videoComp.play();
            } else if (videoComp.status == Video.EndOfMedia) {
                controler++
                timer.start();
            }
        }

        onError: {
            controler++
            timer.start();
        }
    }
}
