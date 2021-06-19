/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2021 MuseScore BVBA and others
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
import QtQuick 2.0
import QtQuick.Controls 2.0
import MuseScore.UiComponents 1.0
import MuseScore.Ui 1.0
import MuseScore.NotationScene 1.0

Item {
    id: root

    ChordSymbolStyleEditorModel{
        id: chordSymbolStyleEditorModel
    }
    Button{
        height: 100
        width: 200
        text: "HI"
    }
    Button{
        anchors.right: root.right
        height: 100
        width: 200
        text: "HI"
    }

    height: 800

        Component {
            id: styleDelegate

            FlatButton {
                id: button

                width: grid.cellWidth-5
                height: grid.cellHeight-5

                Text {
                    text: styleName

                    width: button.width
                    height: button.height

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.Wrap
                }

//                onClicked: {
//                    chordStylesModel.setChordStyle(styleName)
//                    grid.currentIndex = index
//                }
            }
        }

        GridView {
            id: grid

            model: chordSymbolStyleEditorModel

            anchors.bottom: root.bottom

            height: 2*cellHeight
            width: 2*cellWidth

            cellWidth: 120
            cellHeight: 60

            delegate: styleDelegate
            clip: true

            highlight: Rectangle {
                color: ui.theme.accentColor
                radius: 3
            }
        }
}

