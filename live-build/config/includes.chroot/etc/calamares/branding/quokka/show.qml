// Quokka OS — Calamares slideshow (minimal single-slide version)
// slideshowAPI: 2 前提。複数スライドにする場合は Presentation { Slide { ... } } を追加する。
import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#000410"

            Image {
                source: "logo.png"
                anchors.centerIn: parent
                width: 160
                height: 160
                fillMode: Image.PreserveAspectFit
            }

            Text {
                anchors.top: parent.verticalCenter
                anchors.topMargin: 110
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Quokka OS をインストールしています…"
                color: "#00CFFE"
                font.pixelSize: 18
                font.family: "JetBrains Mono"
            }
        }
    }

    function nextSlide() {
        presentation.goToNextSlide();
    }

    Timer {
        interval: 20000
        running: true
        repeat: true
        onTriggered: presentation.nextSlide()
    }
}
