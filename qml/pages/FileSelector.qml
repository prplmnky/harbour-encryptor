import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.encryptor.SailfishWidgets.Components 1.1
import harbour.encryptor.SailfishWidgets.JS 1.1
import harbour.encryptor.Encryptor 1.0

/*!
  Only handles selecting files and returns those files back to user

  Qml                           Instantiates
  This dialog -------------> Qml DirectoryInfo (handles all operations)
                                Sends back
  dynamically <-------------- list of QFiles matching request
  populates list view
  */
Dialog {
    property alias directory: fileList
    property alias filter: fileList.filter
    property alias header: listView.header
    property alias sort: fileList.sort
    property bool multiSelect: false
    property bool quickSelect: false //should be based on file filter
    property string acceptText
    property string baseDirectory: fileList.XdgHome
    property string cancelText
    property string deselectText
    property string headerTitle
    property string selectText
    property variant selectedFiles: []

    property enumeration myval

    canAccept: !!selectedFiles && !!(selectedFiles.length)
    id: fileSelector

    BasicListView {
        anchors.fill: parent
        id: listView

        property variant selectedListItems: []

        header: DialogHeader {
            acceptText: fileSelector.acceptText
            cancelText: fileSelector.cancelText
            id: dialogHeader
            title: fileSelector.headerTitle
        }

        model: fileList.files

        delegate: ListItem {
            id: contentItem
            menu: contextMenuComponent
            property bool selected: false
            property File file: modelData

            Image {
                x: Theme.paddingSmall
                height: file.dir ? parent.height - Theme.paddingSmall : 0
                width: height
                id: icon
                source: file.dir ? IconThemes.iconDirectory : ""
            }

            InformationalLabel {
                anchors.left: icon.right
                anchors.leftMargin: Theme.paddingSmall
                anchors.verticalCenter: parent.verticalCenter
                color: selected ? Theme.primaryColor : Theme.highlightColor
                text: file.fileName
            }

            onClicked: {
                if(file.dir) {
                    fileList.path = file.absoluteFilePath
                } else {
                    if(quickSelect) makeSelection(this)
                }
            }
        }


        Component {
            id:contextMenuComponent
            ContextMenu {
                id: context
                StandardMenuItem {
                    text: !!context.parent ? (context.parent.selected ? deselectText : selectText) : ""
                    onClicked: {
                        makeSelection(context.parent)
                    }
                }
            }
        }

        VerticalScrollDecorator {}
    }

    Dir {
        id: fileList
        filter: Dir.NoFilter
        sort: Dir.DirsFirst | Dir.Name

        onPathChanged: {clearSelection(); refresh()}
    }

    onBaseDirectoryChanged: fileList.path = baseDirectory

    onRejected: clearSelection()

    function clearSelection() {
        for(var i = 0; !!selectedFiles && i < selectedFiles.length; i++) makeSelection(listView.selectedListItems[i])
    }

    function makeSelection(li) {
        if(li.selected) {
            //deselect
            listView.selectedListItems = Variant.remove(listView.selectedListItems, li)
            selectedFiles = Variant.remove(selectedFiles, li.file)

            li.selected = false
        } else {
            if(!multiSelect) {
                //remove previous entries
                for(var i = 0; i < listView.selectedListItems.length; i++) {
                    listView.selectedListItems[i].selected = false
                }
                listView.selectedListItems = []
                selectedFiles = []
            }
            listView.selectedListItems = Variant.add(listView.selectedListItems, li)
            selectedFiles = Variant.add(selectedFiles, li.file)

            li.selected = true
        }

        canAccept = selectedFiles.length
    }

}


