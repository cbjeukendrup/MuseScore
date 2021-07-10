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
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import MuseScore.UiComponents 1.0
import MuseScore.Ui 1.0
import MuseScore.NotationScene 1.0

Rectangle {
    id: root
    color: ui.theme.backgroundPrimaryColor

    ChordSymbolEditorModel {
        id: chordSymbolEditorModel
    }

    Component {
        id: chordStyleDelegate

        FlatButton {
            id: button

            width: 170
            height: 76

            text: styleName

            onClicked: {
                chordSymbolEditorModel.setChordStyle(styleName)
            }
        }
    }

    // ColumnLayout makes it easy to have some items with a fixed height,
    // and make the other items fill the remaining height
    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        StyledTextLabel {
            text: qsTrc("notation", "Chord symbols")
            font: ui.theme.headerBoldFont // Correct font
        }

        StyledTextLabel {
            text: qsTrc("notation", "Choose a style")
        }

        // Changed them all to ListViews
        ListView {
            id: chordSymbolStyleList
            Layout.fillWidth: true

            height: 76
            spacing: 12

            clip: true
            orientation: Qt.Horizontal

            model: chordSymbolEditorModel
            currentIndex: chordSymbolEditorModel.currentStyleIndex

            delegate: chordStyleDelegate

            highlight: Rectangle {
                color: ui.theme.accentColor
                radius: 3
            }
        }

        // We have a component for this (so that can be used instead of a Rectangle every time)
        SeparatorLine {}

        StyledTextLabel {
            text: qsTrc("notation","Adjust settings for ")
        }

        TabBar {
            id: bar

            StyledTabButton {
                text: qsTrc("notation", "Basic")
                sideMargin: 40
                isCurrent: bar.currentIndex === 0
            }

            StyledTabButton {
                text: qsTrc("notation", "Advanced")
                sideMargin: 40
                isCurrent: bar.currentIndex === 1
            }
        }

        StackLayout {
            id: editorStack
            // We shouldn't use anchors.top in a column. Therefore, I switched to
            // ColumnLayout and used the attached fillHeight property to make this
            // item fill the remaining height
            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: bar.currentIndex

            ChordSymbolEditorBasic {
                editorModel: chordSymbolEditorModel
            }

            ChordSymbolEditorAdvanced {
                editorModel: chordSymbolEditorModel
            }
        }
    }
}
