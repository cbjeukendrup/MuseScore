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

#ifndef CHORDSYMBOLEDITORMODEL_H
#define CHORDSYMBOLEDITORMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include "modularity/ioc.h"
#include "context/iglobalcontext.h"
#include "engraving/libmscore/style.h"
#include "notation/internal/chordsymbolstylemanager.h"

class ChordSymbolEditorModel : public QAbstractListModel
{
    INJECT(notation, mu::context::IGlobalContext, globalContext)

    Q_OBJECT

    Q_PROPERTY(QStringList chordSpellingList READ chordSpellingList NOTIFY chordSpellingListChanged)
    Q_PROPERTY(QStringList majorSeventhList READ majorSeventhList NOTIFY majorSeventhListChanged)
    Q_PROPERTY(QStringList halfDiminishedList READ halfDiminishedList NOTIFY halfDiminishedListChanged)
    Q_PROPERTY(QStringList minorList READ minorList NOTIFY minorListChanged)
    Q_PROPERTY(QStringList augmentedList READ augmentedList NOTIFY augmentedListChanged)
    Q_PROPERTY(QStringList diminishedList READ diminishedList NOTIFY diminishedListChanged)
    Q_PROPERTY(QStringList omitList READ omitList NOTIFY omitListChanged)

    Q_PROPERTY(int chordSpellingIndex READ chordSpellingIndex NOTIFY chordSpellingIndexChanged)
    Q_PROPERTY(int currentStyleIndex READ currentStyleIndex NOTIFY currentStyleIndexChanged)
    Q_PROPERTY(int majorSeventhIndex READ majorSeventhIndex NOTIFY majorSeventhIndexChanged)
    Q_PROPERTY(int halfDiminishedIndex READ halfDiminishedIndex NOTIFY halfDiminishedIndexChanged)
    Q_PROPERTY(int minorIndex READ minorIndex NOTIFY minorIndexChanged)
    Q_PROPERTY(int augmentedIndex READ augmentedIndex NOTIFY augmentedIndexChanged)
    Q_PROPERTY(int diminishedIndex READ diminishedIndex NOTIFY diminishedIndexChanged)
    Q_PROPERTY(int omitIndex READ omitIndex NOTIFY omitIndexChanged)

    Q_PROPERTY(qreal qualityMag READ qualityMag NOTIFY qualityMagChanged)
    Q_PROPERTY(qreal qualityAdjust READ qualityAdjust NOTIFY qualityAdjustChanged)
    Q_PROPERTY(qreal extensionMag READ extensionMag NOTIFY extensionMagChanged)
    Q_PROPERTY(qreal extensionAdjust READ extensionAdjust NOTIFY extensionAdjustChanged)
    Q_PROPERTY(qreal modifierMag READ modifierMag NOTIFY modifierMagChanged)
    Q_PROPERTY(qreal modifierAdjust READ modifierAdjust NOTIFY modifierAdjustChanged)

    Q_PROPERTY(qreal harmonyFretDistance READ harmonyFretDistance NOTIFY harmonyFretDistanceChanged)
    Q_PROPERTY(qreal minHarmonyDistance READ minHarmonyDistance NOTIFY minHarmonyDistanceChanged)
    Q_PROPERTY(qreal maxHarmonyBarDistance READ maxHarmonyBarDistance NOTIFY maxHarmonyBarDistanceChanged)
    Q_PROPERTY(qreal maxChordShiftAbove READ maxChordShiftAbove NOTIFY maxChordShiftAboveChanged)
    Q_PROPERTY(qreal maxChordShiftBelow READ maxChordShiftBelow NOTIFY maxChordShiftBelowChanged)
    Q_PROPERTY(qreal capoFretPosition READ capoFretPosition NOTIFY capoFretPositionChanged)

    Q_PROPERTY(qreal stackModifiers READ stackModifiers NOTIFY stackModifiersChanged)

    Q_PROPERTY(qreal autoCapitalization READ autoCapitalization NOTIFY autoCapitalizationChanged)
    Q_PROPERTY(qreal minorRootCapitalization READ minorRootCapitalization NOTIFY minorRootCapitalizationChanged)
    Q_PROPERTY(qreal qualitySymbolsCapitalization READ qualitySymbolsCapitalization NOTIFY qualitySymbolsCapitalizationChanged)
    Q_PROPERTY(qreal bassNotesCapitalization READ bassNotesCapitalization NOTIFY bassNotesCapitalizationChanged)
    Q_PROPERTY(qreal solfegeNotesCapitalization READ solfegeNotesCapitalization NOTIFY solfegeNotesCapitalizationChanged)

    Q_PROPERTY(qreal alterationsParentheses READ alterationsParentheses NOTIFY alterationsParenthesesChanged)
    Q_PROPERTY(qreal suspensionsParentheses READ suspensionsParentheses NOTIFY suspensionsParenthesesChanged)
    Q_PROPERTY(qreal minMajParentheses READ minMajParentheses NOTIFY minMajParenthesesChanged)
    Q_PROPERTY(qreal addOmitParentheses READ addOmitParentheses NOTIFY addOmitParenthesesChanged)

public:
    ChordSymbolEditorModel(QObject* parent = nullptr);

    QVariant data(const QModelIndex& index, int role) const override;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;

    QStringList chordSpellingList() const;
    QStringList majorSeventhList() const;
    QStringList halfDiminishedList() const;
    QStringList minorList() const;
    QStringList augmentedList() const;
    QStringList diminishedList() const;
    QStringList omitList() const;

    int chordSpellingIndex() const;
    int currentStyleIndex() const;
    int majorSeventhIndex() const;
    int halfDiminishedIndex() const;
    int minorIndex() const;
    int augmentedIndex() const;
    int diminishedIndex() const;
    int omitIndex() const;

    qreal qualityMag() const;
    qreal qualityAdjust() const;
    qreal extensionMag() const;
    qreal extensionAdjust() const;
    qreal modifierMag() const;
    qreal modifierAdjust() const;

    qreal harmonyFretDistance() const;
    qreal minHarmonyDistance() const;
    qreal maxHarmonyBarDistance() const;
    qreal maxChordShiftAbove() const;
    qreal maxChordShiftBelow() const;
    qreal capoFretPosition() const;

    qreal stackModifiers() const;

    qreal autoCapitalization() const;
    qreal minorRootCapitalization() const;
    qreal qualitySymbolsCapitalization() const;
    qreal bassNotesCapitalization() const;
    qreal solfegeNotesCapitalization() const;

    qreal alterationsParentheses() const;
    qreal suspensionsParentheses() const;
    qreal minMajParentheses() const;
    qreal addOmitParentheses() const;

    void initCurrentStyleIndex();
    void setQualitySymbolsOnStyleChange();
    void setPropertiesOnStyleChange();
    void setQualitySymbolsLists();
    void setPropertiesOfQualitySymbol(Ms::QualitySymbol qS);
    void stringifyAndSaveSelectionHistory();
    void extractSelectionHistory(QString selectionHistory);
    void updateSelectionHistory(QString currentStyle);
    void setStyleR(Ms::Sid id, qreal val);
    void setStyleB(Ms::Sid id, bool val);

    Q_INVOKABLE void setChordStyle(QString styleName);
    Q_INVOKABLE void setChordSpelling(QString spelling);
    Q_INVOKABLE void setQualitySymbol(QString quality, QString symbol);
    Q_INVOKABLE void setProperty(QString property, qreal val);

signals:
    void chordSpellingListChanged();
    void majorSeventhListChanged();
    void halfDiminishedListChanged();
    void minorListChanged();
    void augmentedListChanged();
    void diminishedListChanged();
    void omitListChanged();

    void chordSpellingIndexChanged();
    void currentStyleIndexChanged();
    void majorSeventhIndexChanged();
    void halfDiminishedIndexChanged();
    void minorIndexChanged();
    void augmentedIndexChanged();
    void diminishedIndexChanged();
    void omitIndexChanged();

    void qualityMagChanged();
    void qualityAdjustChanged();
    void extensionMagChanged();
    void extensionAdjustChanged();
    void modifierMagChanged();
    void modifierAdjustChanged();

    void harmonyFretDistanceChanged();
    void minHarmonyDistanceChanged();
    void maxHarmonyBarDistanceChanged();
    void maxChordShiftAboveChanged();
    void maxChordShiftBelowChanged();
    void capoFretPositionChanged();

    void stackModifiersChanged();

    void autoCapitalizationChanged();
    void minorRootCapitalizationChanged();
    void qualitySymbolsCapitalizationChanged();
    void bassNotesCapitalizationChanged();
    void solfegeNotesCapitalizationChanged();

    void alterationsParenthesesChanged();
    void suspensionsParenthesesChanged();
    void minMajParenthesesChanged();
    void addOmitParenthesesChanged();

private:
    enum RoleNames {
        StyleNameRole = Qt::UserRole + 1,
        FileRole,
        UsePresetsRole
    };

    QList<Ms::ChordSymbolStyle> m_styles;
    ChordSymbolStyleManager* styleManager;
    QHash<QString, QList<Ms::QualitySymbol>> m_qualitySymbols;
    QHash<QString, QHash<QString, QVariant> > m_selectionHistory;

    QStringList m_chordSpellingList;
    QList<Ms::QualitySymbol> m_majorSeventhList;
    QList<Ms::QualitySymbol> m_halfDiminishedList;
    QList<Ms::QualitySymbol> m_minorList;
    QList<Ms::QualitySymbol> m_augmentedList;
    QList<Ms::QualitySymbol> m_diminishedList;
    QList<Ms::QualitySymbol> m_omitList;

    int m_chordSpellingIndex;
    int m_currentStyleIndex;
    int m_majorSeventhIndex;
    int m_halfDiminishedIndex;
    int m_minorIndex;
    int m_augmentedIndex;
    int m_diminishedIndex;
    int m_omitIndex;

    qreal m_qualityMag;
    qreal m_qualityAdjust;
    qreal m_extensionMag;
    qreal m_extensionAdjust;
    qreal m_modifierMag;
    qreal m_modifierAdjust;

    qreal m_harmonyFretDistance;
    qreal m_minHarmonyDistance;
    qreal m_maxHarmonyBarDistance;
    qreal m_maxChordShiftAbove;
    qreal m_maxChordShiftBelow;
    qreal m_capoFretPosition;

    qreal m_stackModifiers;

    qreal m_autoCapitalization;
    qreal m_minorRootCapitalization;
    qreal m_qualitySymbolsCapitalization;
    qreal m_bassNotesCapitalization;
    qreal m_solfegeNotesCapitalization;

    qreal m_alterationsParentheses;
    qreal m_suspensionsParentheses;
    qreal m_minMajParentheses;
    qreal m_addOmitParentheses;

    QHash<QString, Ms::Sid> chordSpellingMap = {
        { "Standard", Ms::Sid::useStandardNoteNames },
        { "German", Ms::Sid::useGermanNoteNames },
        { "German Full", Ms::Sid::useFullGermanNoteNames },
        { "Solfege", Ms::Sid::useSolfeggioNoteNames },
        { "French", Ms::Sid::useFrenchNoteNames }
    };
};

#endif // CHORDSYMBOLEDITORMODEL_H
