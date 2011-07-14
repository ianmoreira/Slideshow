import QtQuick 1.0

Item {
    width: 308
    height: 368

    property int internControl: 1
    property int i: 1
    property bool playing: true

    Image {
        visible:  playing
        source:  "images/loading/loading_0"+ i +".png"
    }

    Timer {
        id: loadingTimer
        interval: 50
        running: playing
        repeat: true
        onTriggered: {
            internControl++
            if(internControl > 8) {
                internControl = 1;
            }

            i = internControl;
        }
    }
}
