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

#include <targetconditionals.h>

#if defined(TARGET_OS_IPHONE)
#include <UIKit/UIKit.h>
#else
#include <Cocoa/Cocoa.h>
#endif

#include "macosrecentfilescontroller.h"

using namespace mu::project;

void MacOSRecentFilesController::prependPlatformRecentFile(const muse::io::path_t& path)
{
#ifndef Q_OS_IOS
    NSString* string = path.toQString().toNSString();
    NSURL* url = [NSURL fileURLWithPath:string];
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:url];
#endif
}

void MacOSRecentFilesController::clearPlatformRecentFiles()
{
#ifndef Q_OS_IOS
    [[NSDocumentController sharedDocumentController] clearRecentDocuments:nil];
#endif
}
