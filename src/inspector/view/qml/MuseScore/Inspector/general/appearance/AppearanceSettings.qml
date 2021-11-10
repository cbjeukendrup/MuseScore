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

import MuseScore.Ui 1.0
import MuseScore.UiComponents 1.0

import "../../common"
import "internal"

Column {
    id: root

    property QtObject model: null

    property NavigationPanel navigationPanel: null

    height: implicitHeight
    width: parent.width

    spacing: 12

    function focusOnFirst() {
        horizontalSpacingSection.focusOnFirst()
    }

    HorizontalSpacingSection {
        id: horizontalSpacingSection
        leadingSpace: root.model?.leadingSpace ?? null
        barWidth: root.model?.barWidth ?? null

        navigationPanel: root.navigationPanel
        navigationRowStart: 0
    }

    SeparatorLine { anchors.margins: -12 }

    VerticalSpacingSection {
        id: verticalSpacingSection

        minimumDistance: root.model?.minimumDistance ?? null

        navigationPanel: root.navigationPanel
        navigationRowStart: horizontalSpacingSection.navigationRowEnd + 1
    }

    SeparatorLine { anchors.margins: -12 }

    AppearanceOffsetSection {
        id: offsetSection

        horizontalOffset: root.model?.horizontalOffset ?? null
        verticalOffset: root.model?.verticalOffset ?? null
        isSnappedToGrid: root.model?.isSnappedToGrid ?? false

        navigationPanel: root.navigationPanel
        navigationRowStart: verticalSpacingSection.navigationRowEnd + 1

        onSnapToGridToggled: function(snap) {
            if (root.model) {
                root.model.isSnappedToGrid = snap
            }
        }

        onConfigureGridRequested: {
            root.model?.configureGrid()
        }
    }

    SeparatorLine { anchors.margins: -12 }

    ArrangeSection {
        id: arrangeSection

        navigationPanel: root.navigationPanel
        navigationRowStart: offsetSection.navigationRowEnd

        onPushBackRequested: {
            root.model?.pushBackInOrder()
        }

        onPushFrontRequested: {
            root.model?.pushFrontInOrder()
        }
    }

    SeparatorLine { anchors.margins: -12 }

    ColorSection {
        propertyItem: root.model?.color ?? null

        navigationPanel: root.navigationPanel
        navigationRowStart: arrangeSection.navigationRowEnd
    }
}
