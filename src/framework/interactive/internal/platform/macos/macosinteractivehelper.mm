/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2022 MuseScore Limited and others
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
#include "macosinteractivehelper.h"

#include <QUrl>
#include <QStandardPaths>

// NSWorkspace does not exist on iOS, if we need these calls for regular app use,
// we will come up with something equivalent. Until then, we're stubbing them out.
#ifdef Q_OS_IOS
#include <UIKit/UIKit.h>
#else
#include <Cocoa/Cocoa.h>
#endif

#include "types/uri.h"

#include "log.h"

#include <sstream>

using namespace muse;
using namespace muse::async;
using namespace kors::logger;

bool MacOSInteractiveHelper::revealInFinder(const io::path_t& filePath)
{
#ifdef Q_OS_IOS
    std::stringstream aStream;
    aStream << __PRETTY_FUNCTION__ << " is not implemented, trying to open filePath: " << filePath.c_str();
    LogMsg(std::string("Unimplemented"), aStream.str(), Color::Magenta);
    return false;
#else
    NSURL* fileUrl = QUrl::fromLocalFile(filePath.toQString()).toNSURL();
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[fileUrl]];
    return true;
#endif
}

Ret MacOSInteractiveHelper::isAppExists(const std::string& appIdentifier)
{
#ifdef Q_OS_IOS
    std::stringstream aStream;
    aStream << __PRETTY_FUNCTION__ << " is not implemented, appIdentifier: " << appIdentifier;
    LogMsg(std::string("Unimplemented"), aStream.str(), Color::Magenta);
    return false;
#else
    NSWorkspace* workspace = [NSWorkspace sharedWorkspace];
    NSURL* appURL = [workspace URLForApplicationWithBundleIdentifier:@(appIdentifier.c_str())];
    return appURL != nil;
#endif
}

Ret MacOSInteractiveHelper::canOpenApp(const UriQuery& uri)
{
    NSString* nsUrlString = [NSString stringWithUTF8String:uri.toString().c_str()];
    if (nsUrlString == nil) {
        return make_ret(Ret::Code::InternalError, std::string("Invalid UTF-8 string passed as URI"));
    }

#ifdef Q_OS_IOS
    std::stringstream aStream;
    aStream << __PRETTY_FUNCTION__ << " is not implemented, uri: " << uri.toString().c_str();
    return make_ret(Ret::Code::NotImplemented, aStream.str());
#else
    NSURL* nsUrl = [NSURL URLWithString:nsUrlString];
    if (nsUrl == nil) {
        return make_ret(Ret::Code::InternalError, std::string("Invalid URI"));
    }

    NSURL* appURL = [[NSWorkspace sharedWorkspace] URLForApplicationToOpenURL:nsUrl];
    return appURL != nil;
#endif
}

async::Promise<Ret> MacOSInteractiveHelper::openApp(const UriQuery& uri)
{
#ifdef Q_OS_IOS
    return Promise<Ret>([uri](auto /*resolve*/, auto reject) {
        std::stringstream aStream;
        aStream << __PRETTY_FUNCTION__ << " is not implemented, uri: " << uri.toString();
        return reject(int(Ret::Code::NotImplemented), aStream.str());
    });
#else
    return Promise<Ret>([uri](auto resolve, auto reject) {
        NSString* nsUrlString = [NSString stringWithUTF8String:uri.toString().c_str()];
        if (nsUrlString == nil) {
            return reject(int(Ret::Code::InternalError), "Invalid UTF-8 string passed as URI");
        }

        NSURL* nsUrl = [NSURL URLWithString:nsUrlString];
        if (nsUrl == nil) {
            return reject(int(Ret::Code::InternalError), "Invalid URI");
        }

        auto configuration = [NSWorkspaceOpenConfiguration configuration];
        [configuration setPromptsUserIfNeeded:NO];
        [[NSWorkspace sharedWorkspace]
         openURL: nsUrl
         configuration: configuration
         completionHandler: ^(NSRunningApplication*, NSError* error) {
             if (error) {
                 std::string errorStr = [[error description] UTF8String];
                 (void)reject(int(Ret::Code::InternalError), errorStr);
             } else {
                 (void)resolve(make_ok());
             }
         }
        ];

        return Promise<Ret>::Result::unchecked();
    });
#endif
}
