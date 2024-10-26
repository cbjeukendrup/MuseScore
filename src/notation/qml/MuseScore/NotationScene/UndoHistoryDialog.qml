/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-Studio-CLA-applies
 *
 * MuseScore Studio
 * Music Composition & Notation
 *
 * Copyright (C) 2021 MuseScore Limited
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.15
import QtQuick.Layouts 1.15

import Muse.Ui 1.0
import Muse.UiComponents 1.0
import MuseScore.NotationScene 1.0

StyledDialogView {
    id: root
    
    title: qsTrc("notation", "Undo/redo history")
    modal: true

    contentWidth: content.implicitWidth
    contentHeight: 360
    margins: 16

    resizable: true

    Component.onCompleted: {
        undoRedoHistoryModel.load()
    }

    UndoRedoHistoryModel {
        id: undoRedoHistoryModel
    }

    property int selectedRowIndex: undoRedoHistoryModel.currentActionRowIndex
    readonly property int selectedActionIndex: undoRedoHistoryModel.rowIndexToActionIndex(selectedRowIndex)

    function done() {
        root.ret = { errcode: 0, value: selectedActionIndex }
        root.hide()
    }

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: 16

        NavigationPanel {
            id: navPanel
            name: "UndoRedoItemsView"
            section: root.navigationSection
            direction: NavigationPanel.Vertical
            order: 1
            accessible.name: qsTrc("notation", "Undo/redo history list")
        }

        StyledTextLabel {
            Layout.fillWidth: true

            text: qsTrc("notation", "Select one or more actions to undo or redo")
            font: ui.theme.bodyBoldFont
            horizontalAlignment: Text.AlignLeft
        }

        StyledListView {
            id: listView

            Layout.fillWidth: true
            Layout.fillHeight: true

            model: undoRedoHistoryModel

            delegate: ListItemBlank {
                isSelected: root.selectedRowIndex === model.index

                navigation.panel: navPanel
                navigation.order: index
                navigation.accessible.name: model.actionName
                navigation.accessible.row: model.index

                StyledTextLabel {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.right: parent.right
                    anchors.rightMargin: 12

                    text: model.actionName
                    font: ui.theme.bodyBoldFont
                    horizontalAlignment: Text.AlignLeft
                }

                onClicked: {
                    root.selectedRowIndex = model.index
                }

                onDoubleClicked: {
                    root.done()
                }
            }
        }

        ButtonBox {
            Layout.alignment: Qt.AlignRight | Qt.AlignBottom

            navigationPanel.section: root.navigationSection
            navigationPanel.order: 2

            buttons: [ ButtonBoxModel.Cancel ]

            onStandardButtonClicked: {
                if (buttonId === ButtonBoxModel.Cancel) {
                    root.reject()
                }
            }

            FlatButton {
                text: qsTrc("global", "OK")
                buttonRole: ButtonBoxModel.AcceptRole
                buttonId: ButtonBoxModel.Ok
                enabled: true
                accentButton: true

                onClicked: {
                    root.done()
                }
            }
        }
    }
}
