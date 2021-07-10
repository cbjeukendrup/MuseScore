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

import MuseScore.UiComponents 1.0
import MuseScore.Ui 1.0
import MuseScore.NotationScene 1.0 // needed for ChordSymbolEditorModel

// Let's remove the `Item {`, because it does not do anything useful
// I don't re-format the code for now to keep the diff slightly easier to understand
    Flickable {
        id: root

        // A bit safer to use ChordSymbolEditorModel instead of `var`, and useful for code completion
        property ChordSymbolEditorModel editorModel: null

        contentWidth: width
        contentHeight: content.height

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: StyledScrollBar {}

        Row {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 24

            Column {
                id: leftColumn
                width: (content.width - content.spacing) / 2
                spacing: 18

                StyledTextLabel{
                    text: qsTrc("notation", "Quality")
                    // The correct font
                    font: ui.theme.bodyBoldFont
                }

                Row {
                    width: parent.width
                    spacing: 12

                    // Let's make a separate item for this, we'll need it so often
                    SpinBoxWithTitle {
                        id: qualityAdjustSpinBox
                        width: Math.min(126, (parent.width - parent.spacing) / 2)
                        text: qsTrc("notation", "Vertical Offset")

                        currentValue: root.editorModel.qualityAdjust
                        step: 1
                        minValue: -10
                        maxValue: 10

                        onValueEdited: root.editorModel.setProperty("QualityAdjust", newValue)
                    }

                    SpinBoxWithTitle {
                        id: qualityMagSpinBox
                        width: Math.min(126, (parent.width - parent.spacing) / 2)
                        text: qsTrc("notation", "Scaling")

                        currentValue: root.editorModel.qualityMag
                        step: 0.1
                        minValue: -10
                        maxValue: 10

                        onValueEdited: root.editorModel.setProperty("QualityMag", newValue)
                    }
                }

                // Please use spaces before `{` and after `,`
                StyledTextLabel {
                    text: qsTrc("notation", "Extensions")
                }

                Row{
                    // TODO: Replace these ones with the new SpinBoxWithTitle
                    Column{
                        StyledTextLabel{
                            text: qsTrc("notation","Vertical Offset")
                        }

                        IncrementalPropertyControl {
                            id: extensionAdjustSpinBox

                            width: root.width/4

                            // `root.editorModel` is better than just `editorModel`
                            currentValue: root.editorModel.extensionAdjust

                            step: 1
                            minValue: -10
                            maxValue: 10

                            onValueEdited: root.editorModel.setProperty("ExtensionAdjust", newValue)
                        }
                    }

                    Column{
                        StyledTextLabel{
                            text: qsTrc("notation","Scaling")
                        }

                        IncrementalPropertyControl {
                            id: extensionMagSpinBox

                            width: root.width/4

                            currentValue: root.editorModel.extensionMag

                            step: 0.1
                            minValue: -10
                            maxValue: 10

                            onValueEdited: root.editorModel.setProperty("ExtensionMag", newValue)
                        }
                    }

                }

                StyledTextLabel{
                    text: qsTrc("notation","Alterations")
                }

                Row{
                    Column{
                        StyledTextLabel{
                            text: qsTrc("notation","Vertical Offset")
                        }

                        IncrementalPropertyControl {
                            id: modifierAdjustSpinBox

                            width: root.width/4

                            currentValue: root.editorModel.modifierAdjust

                            step: 1
                            minValue: -10
                            maxValue: 10

                            onValueEdited: root.editorModel.setProperty("ModifierAdjust", newValue)
                        }
                    }

                    Column{
                        StyledTextLabel{
                            text: qsTrc("notation","Scaling")
                        }

                        IncrementalPropertyControl {
                            id: modifierMagSpinBox

                            width: root.width/4

                            currentValue: root.editorModel.modifierMag

                            step: 0.1
                            minValue: -10
                            maxValue: 10

                            onValueEdited: root.editorModel.setProperty("ModifierMag", newValue)
                        }
                    }

                }
                StyledTextLabel{
                    text: qsTrc("notation","Positioning")
                }

                Column{
                    StyledTextLabel{
                        text: qsTrc("notation","Minimum chord spacing")
                    }

                    IncrementalPropertyControl {
                        id: chordSpacingSpinBox

                        width: root.width/4

                        currentValue: root.editorModel.minHarmonyDistance
                        measureUnitsSymbol: qsTrc("notation", "sp")

                        step: 0.1
                        minValue: -50
                        maxValue: 10

                        onValueEdited: root.editorModel.setProperty("minHarmonyDistance", newValue)
                    }
                }

                Column{
                    StyledTextLabel{
                        text: qsTrc("notation","Minimum barline distance")
                    }

                    IncrementalPropertyControl {
                        id: barlineDistanceSpinBox

                        width: root.width/4

                        currentValue: root.editorModel.maxHarmonyBarDistance
                        measureUnitsSymbol: qsTrc("notation", "sp")

                        step: 0.5
                        minValue: -50
                        maxValue: 50

                        onValueEdited: root.editorModel.setProperty("maxHarmonyBarDistance", newValue)
                    }
                }

                Column{
                    StyledTextLabel{
                        text: qsTrc("notation","Distance to fretboard diagram")
                    }

                    IncrementalPropertyControl {
                        id: distToFretboardSpinBox

                        width: root.width/4

                        currentValue: root.editorModel.harmonyFretDistance
                        measureUnitsSymbol: qsTrc("notation", "sp")

                        step: 0.5
                        minValue: -10000
                        maxValue: 10000

                        onValueEdited: root.editorModel.setProperty("HarmonyFretDistance", newValue)
                    }
                }
                Row{
                    Column{
                        StyledTextLabel{
                            text: qsTrc("notation","Minimum shift above")
                        }

                        IncrementalPropertyControl {
                            id: shiftBelowSpinBox

                            width: root.width/4

                            currentValue: root.editorModel.maxChordShiftAbove
                            measureUnitsSymbol: qsTrc("notation", "sp")

                            step: 0.5
                            minValue: 0
                            maxValue: 100

                            onValueEdited: root.editorModel.setProperty("maxChordShiftAbove", newValue)
                        }
                    }

                    Column{
                        StyledTextLabel{
                            text: qsTrc("notation","Minimum shift below")
                        }

                        IncrementalPropertyControl {
                            id: shiftAboveSpinBox

                            width: root.width/4

                            currentValue: root.editorModel.maxChordShiftBelow
                            measureUnitsSymbol: qsTrc("notation", "sp")

                            step: 0.5
                            minValue: 0
                            maxValue: 100

                            onValueEdited: root.editorModel.setProperty("maxChordShiftBelow", newValue)
                        }
                    }

                }
                Column{
                    StyledTextLabel{
                        text: qsTrc("notation","Capo fret position")
                    }

                    IncrementalPropertyControl {
                        id: capoFretSpinBox

                        width: root.width/4

                        currentValue: root.editorModel.capoFretPosition

                        step: 1
                        minValue: 0
                        maxValue: 11

                        onValueEdited: root.editorModel.setProperty("capoPosition", newValue)
                    }
                }
            }

            // I made a beginning with this to check that it will look correct
            Column {
                id: rightColumn
                width: (content.width - content.spacing) / 2
                spacing: 18

                StyledTextLabel{
                    text: qsTrc("notation", "Capitalization")
                    font: ui.theme.bodyBoldFont
                }
            }
        }
    }
