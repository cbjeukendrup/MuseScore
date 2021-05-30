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
#include "scorefontscontroller.h"

#include "libmscore/scorefont.h"
#include "log.h"

#include <QDirIterator>

using namespace mu::notation;

void ScoreFontsController::init()
{
    Ms::ScoreFont::initScoreFonts();

    auto musicFontsPath = configuration()->musicFontsPath();
    musicFontsPath.ch.onReceive(this, [this](const mu::io::path& dir) {
        scanDirectory(dir);
    });

    scanDirectory(musicFontsPath.val);
}

void ScoreFontsController::scanDirectory(const mu::io::path& path) const
{
    std::vector<Ms::ScoreFont> userfonts;

    QDirIterator iterator(path.toQString(), QDir::Dirs | QDir::NoDotAndDotDot | QDir::Readable);

    while (iterator.hasNext()) {
        QString fontDir = iterator.next();
        QString fontDirPath = iterator.filePath() + "/";
        QString fontDirName = iterator.fileName();

        QString fontName;
        QString fontFilename;
        QDirIterator innerIterator(fontDirPath, { "*.otf", "*.ttf" }, QDir::Files);

        while (innerIterator.hasNext()) {
            QString potentialFontFile = innerIterator.next();
            QFileInfo fileinfo(potentialFontFile);

            if (fileinfo.completeBaseName().toLower() == fontDirName.toLower()) {
                fontName = fileinfo.completeBaseName();
                fontFilename = innerIterator.fileName();
                break;
            }
        }

        bool hasMetadataFile = QFileInfo::exists(fontDirPath + "metadata.json");

        if (hasMetadataFile && !fontFilename.isEmpty()) {
            QByteArray name = fontName.toLocal8Bit();
            QByteArray dp = fontDirPath.toLocal8Bit();
            QByteArray fn = fontFilename.toLocal8Bit();
            qDebug() << fontFilename;
            qDebug() << fn;
            userfonts.push_back(Ms::ScoreFont(name.data(), name.data(), dp.data(), fn.data()));
        }
    }

    Ms::ScoreFont::setUserScoreFonts(userfonts);
    LOGI() << "Found " << userfonts.size() << " user score fonts.";
}
