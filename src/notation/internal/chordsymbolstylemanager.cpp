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
#include "chordsymbolstylemanager.h"
#include "framework/global/io/path.h"
#include "engraving/libmscore/mscore.h"

ChordSymbolStyleManager::ChordSymbolStyleManager()
{
    retrieveChordStyles();
}

void ChordSymbolStyleManager::retrieveChordStyles()
{
    mu::io::paths filesFound = scanFileSystemForChordStyles();

    for (mu::io::path& file: filesFound) {
        if (isChordSymbolStylesFile(file)) {
            extractChordStyleInfo(file);
        }
    }
}

mu::io::paths ChordSymbolStyleManager::scanFileSystemForChordStyles()
{
    mu::io::paths result;

    // Are there any other share paths?
    mu::io::path dirPath = Ms::MScore::globalShare();
    mu::RetVal<mu::io::paths> files = fileSystem()->scanFiles(dirPath, { "*.xml" });

    result.insert(result.end(), files.val.begin(), files.val.end());
    return result;
}

QList<Ms::ChordSymbolStyle> ChordSymbolStyleManager::getChordStyles()
{
    return _chordStyles;
}

// Check if the file is a chord symbol style file
bool ChordSymbolStyleManager::isChordSymbolStylesFile(mu::io::path& f)
{
    bool isStyleFile = false;
    QString path = f.toQString();

    QFileInfo ftest(path);
    if (!ftest.isAbsolute()) {
#if defined(Q_OS_IOS)
        path = QString("%1/%2").arg(Ms::MScore::globalShare()).arg(path);
#elif defined(Q_OS_ANDROID)
        path = QString(":/styles/%1").arg(path);
#else
        path = QString("%1styles/%2").arg(Ms::MScore::globalShare(), path);
#endif
    }

    QFile file(path);
    Ms::XmlReader e(&file);
    QFileInfo fi(path);

    if (!file.open(QIODevice::ReadOnly)) {
        return isStyleFile;
    }

    while (e.readNextStartElement()) {
        if (e.name() == "museScore") {
            if (e.attribute("type") == "chordStyle") {
                isStyleFile = true;
                break;
            }
        }
    }

    return isStyleFile;
}

// Extract info from a file that is confirmed as a style file
void ChordSymbolStyleManager::extractChordStyleInfo(mu::io::path& f)
{
    QString path = f.toQString();

    QFileInfo ftest(path);
    if (!ftest.isAbsolute()) {
#if defined(Q_OS_IOS)
        path = QString("%1/%2").arg(Ms::MScore::globalShare()).arg(path);
#elif defined(Q_OS_ANDROID)
        path = QString(":/styles/%1").arg(path);
#else
        path = QString("%1styles/%2").arg(Ms::MScore::globalShare(), path);
#endif
    }

    QFile file(path);
    Ms::XmlReader e(&file);
    QFileInfo fi(path);
    QString styleName = "";
    bool usePresets = false;

    if (!file.open(QIODevice::ReadOnly)) {
        return;
    }

    while (e.readNextStartElement()) {
        if (e.name() == "museScore") {
            if (e.attribute("type") == "chordStyle") {
                styleName = e.attribute("styleName");
                usePresets = (e.attribute("usePresets") == "true");
                break;
            }
        }
    }

    _chordStyles.push_back({ styleName, fi.fileName(), usePresets });
}

// TODO: Rewrite the XML format
QHash<QString, QList<Ms::QualitySymbol> > ChordSymbolStyleManager::getQualitySymbols(QString path)
{
    QHash<QString, QList<Ms::QualitySymbol> > qualitySymbols;

    QFileInfo ftest(path);
    if (!ftest.isAbsolute()) {
#if defined(Q_OS_IOS)
        path = QString("%1/%2").arg(Ms::MScore::globalShare()).arg(path);
#elif defined(Q_OS_ANDROID)
        path = QString(":/styles/%1").arg(path);
#else
        path = QString("%1styles/%2").arg(Ms::MScore::globalShare(), path);
#endif
    }

    QFile file(path);
    Ms::XmlReader e(&file);

    if (!file.open(QIODevice::ReadOnly)) {
        return qualitySymbols;
    }

    while (e.readNextStartElement()) {
        if (e.name() == "museScore") {
            if (e.attribute("type") == "chordStyle") {
                // Inside the MuseScore element now, start reading the quality symbols
                while (e.readNextStartElement()) {
                    if (e.name() == "quality") {
                        QString qual = e.attribute("q");
                        QList<Ms::QualitySymbol> rep;
                        while (e.readNextStartElement()) {
                            if (e.name() == "sym") {
                                Ms::QualitySymbol qualSym;
                                qualSym.qualMag = e.hasAttribute("qMag") ? e.doubleAttribute("qMag") : qualSym.qualMag;
                                qualSym.qualAdjust = e.hasAttribute("qAdj") ? e.doubleAttribute("qAdj") : qualSym.qualAdjust;
                                qualSym.extMag = e.hasAttribute("eMag") ? e.doubleAttribute("eMag") : qualSym.extMag;
                                qualSym.extAdjust = e.hasAttribute("eAdj") ? e.doubleAttribute("eAdj") : qualSym.extAdjust;
                                qualSym.modMag = e.hasAttribute("mMag") ? e.doubleAttribute("mMag") : qualSym.modMag;
                                qualSym.modAdjust = e.hasAttribute("mAdj") ? e.doubleAttribute("mAdj") : qualSym.modAdjust;
                                qualSym.qualitySymbol = e.readElementText();
                                rep << qualSym;
                            }
                        }
                        qualitySymbols.insert(qual, rep);
                    } else if (e.name() == "modifier") {
                        // Created a separate tag for omit just in case
                        // in the future, if modifiers are handled differently
                        QString mod = e.attribute("m");
                        QList<Ms::QualitySymbol> rep;
                        while (e.readNextStartElement()) {
                            if (e.name() == "sym") {
                                Ms::QualitySymbol modSym;
                                modSym.qualMag = e.hasAttribute("qMag") ? e.doubleAttribute("qMag") : modSym.qualMag;
                                modSym.qualAdjust = e.hasAttribute("qAdj") ? e.doubleAttribute("qAdj") : modSym.qualAdjust;
                                modSym.extMag = e.hasAttribute("eMag") ? e.doubleAttribute("eMag") : modSym.extMag;
                                modSym.extAdjust = e.hasAttribute("eAdj") ? e.doubleAttribute("eAdj") : modSym.extAdjust;
                                modSym.modMag = e.hasAttribute("mMag") ? e.doubleAttribute("mMag") : modSym.modMag;
                                modSym.modAdjust = e.hasAttribute("mAdj") ? e.doubleAttribute("mAdj") : modSym.modAdjust;
                                modSym.qualitySymbol = e.readElementText();
                                rep << modSym;
                            }
                        }
                        qualitySymbols.insert(mod, rep);
                    }
                }
            }
        }
    }

    return qualitySymbols;
}
