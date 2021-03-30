import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import MuseScore.UiComponents 1.0
import MuseScore.Ui 1.0

FocusableItem {
    id: root

    property int headerType: Section.TitleOnly

    property string title

    property bool isChecked: true
    property ButtonGroup radioButtonGroup
    signal isCheckedToggled()
    onIsCheckedToggled: {
        if (headerType === Section.CheckBox) {
            isChecked = !isChecked
        }
    }

    property bool isExpanded: true
    signal isExpandedToggled()
    onIsExpandedToggled: {
        isExpanded = !isExpanded
    }

    property alias headerComponent: headerLoader.sourceComponent
    default property alias contentComponent: contentLoader.sourceComponent

    property int spacing: 18

    enum HeaderType {
        TitleOnly,
        CheckBox,
        RadioButton,
        Expandable,
        Custom
    }

    implicitHeight: contentColumn.height
    implicitWidth: parent.width

    Keys.onSpacePressed: {
        if (headerType === Section.Expandable) {
            isExpandedToggled(!isExpanded)
        }
    }

    ColumnLayout {
        id: contentColumn

        width: parent.width
        spacing: root.isExpanded ? root.spacing : 0
        Behavior on spacing { NumberAnimation { duration: 100  } }

        Loader {
            id: headerLoader
            Layout.fillWidth: true

            sourceComponent: {
                switch (headerType) {
                case Section.TitleOnly: return headerComp_titleOnly
                case Section.CheckBox: return headerComp_checkbox
                case Section.RadioButton: return headerComp_radioButton
                case Section.Expandable: return headerComp_expandable
                }
            }
        }

        Loader {
            id: contentLoader
            property alias isExpanded: root.isExpanded
            property alias yScale: scalingFactor.yScale

            Layout.preferredHeight: implicitHeight * yScale

            enabled: isExpanded
            opacity: isExpanded ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 100  } }

            transform: Scale {
                id: scalingFactor
                yScale: isExpanded ? 1 : 0
                Behavior on yScale { NumberAnimation { duration: 100 } }
            }
        }
    }

    Component {
        id: headerComp_titleOnly

        StyledTextLabel {
            text: root.title
            font: ui.theme.bodyBoldFont
            horizontalAlignment: Text.AlignLeft
        }
    }

    Component {
        id: headerComp_checkbox

        CheckBox {
            id: checkbox
            text: root.title
            font: ui.theme.bodyBoldFont

            checked: root.isChecked
            onClicked: root.isCheckedToggled()
        }
    }

    Component {
        id: headerComp_radioButton

        RoundedRadioButton {
            id: headerRadioButton
            text: root.title
            font: ui.theme.bodyBoldFont
            ButtonGroup.group: root.radioButtonGroup
            checked: root.isChecked
            onToggled: root.isCheckedToggled()
        }
    }

    Component {
        id: headerComp_expandable

        Item {
            width: expandableRow.implicitWidth
            height: expandableRow.implicitHeight

            RowLayout {
                id: expandableRow
                spacing: 4

                Rectangle {
                    id: expandButton

                    height: expandButtonIcon.height * 1.2
                    width: expandButtonIcon.width * 1.2

                    color: "transparent"

                    StyledIconLabel {
                        id: expandButtonIcon
                        iconCode: IconCode.SMALL_ARROW_DOWN

                        rotation: root.isExpanded ? 0 : -90

                        Behavior on rotation {
                            NumberAnimation {
                                easing.type: Easing.OutQuad
                                duration: 50
                            }
                        }
                    }
                }

                StyledTextLabel {
                    id: titleLabel
                    text: root.title
                    font: ui.theme.bodyBoldFont
                }
            }

            MouseArea {
                anchors.fill: parent

                hoverEnabled: true
                onClicked: {
                    root.isExpandedToggled(!isExpanded)
                }
            }
        }
    }
}
