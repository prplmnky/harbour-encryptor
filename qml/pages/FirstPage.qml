import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.encryptor.SailfishWidgets.Components 1.1
import harbour.encryptor.Encryptor 1.0

Page {

    property File inFile

    PageColumn {
        title: "GPG Decryption"

        Button {
            text: "Select File"
            onClicked: {
                pageStack.push(fileSelector)
            }
        }

        Label {
            id: results
            text: !!inFile ? inFile.fileName : ""
        }

        FileSelector {
            acceptText: canAccept ? selectedFiles.length + " file(s)" : directory.dirName
            id: fileSelector
            selectText: "Select"
            deselectText: "Deselect"

            onRejected: inFile = null
            onAccepted: inFile = selectedFiles[0]
        }
    }

    Component.onCompleted: {
        console.log("dirs: " + Dir.Dirs)
    }
}
