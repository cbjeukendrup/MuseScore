# SPDX-License-Identifier: GPL-3.0-only
# MuseScore-CLA-applies
#
# MuseScore
# Music Composition & Notation
#
# Copyright (C) 2021 MuseScore BVBA and others
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set(MODULE userscores)

set(MODULE_QRC userscores.qrc)

set(MODULE_QML_IMPORT ${CMAKE_CURRENT_LIST_DIR}/qml)

if (OS_IS_MAC)
    set(PLATFORM_SRC
        ${CMAKE_CURRENT_LIST_DIR}/internal/platform/macos/macosrecentfilescontroller.mm
        ${CMAKE_CURRENT_LIST_DIR}/internal/platform/macos/macosrecentfilescontroller.h
    )
    # Don't mix C++ and Objective-C++ in Unity Build
    set_source_files_properties(${CMAKE_CURRENT_LIST_DIR}/internal/platform/macos/macosrecentfilescontroller.mm
                                PROPERTIES SKIP_UNITY_BUILD_INCLUSION ON)

    set_source_files_properties(${CMAKE_CURRENT_LIST_DIR}/internal/platform/macos/macosrecentfilescontroller.mm
                                PROPERTIES SKIP_PRECOMPILE_HEADERS ON)
elseif(OS_IS_WIN)
    set(PLATFORM_SRC
        ${CMAKE_CURRENT_LIST_DIR}/internal/platform/windows/windowsrecentfilescontroller.cpp
        ${CMAKE_CURRENT_LIST_DIR}/internal/platform/windows/windowsrecentfilescontroller.h
    )
else()
    set(PLATFORM_SRC
        ${CMAKE_CURRENT_LIST_DIR}/internal/platform/stub/stubrecentfilescontroller.cpp
        ${CMAKE_CURRENT_LIST_DIR}/internal/platform/stub/stubrecentfilescontroller.h
    )
endif()

set(MODULE_SRC
    ${CMAKE_CURRENT_LIST_DIR}/userscoresmodule.cpp
    ${CMAKE_CURRENT_LIST_DIR}/userscoresmodule.h
    ${CMAKE_CURRENT_LIST_DIR}/iuserscoresconfiguration.h
    ${CMAKE_CURRENT_LIST_DIR}/iuserscoresservice.h
    ${CMAKE_CURRENT_LIST_DIR}/ifilescorecontroller.h
    ${CMAKE_CURRENT_LIST_DIR}/iexportscorescenario.h
    ${CMAKE_CURRENT_LIST_DIR}/userscorestypes.h
    ${CMAKE_CURRENT_LIST_DIR}/view/recentscoresmodel.cpp
    ${CMAKE_CURRENT_LIST_DIR}/view/recentscoresmodel.h
    ${CMAKE_CURRENT_LIST_DIR}/view/newscoremodel.cpp
    ${CMAKE_CURRENT_LIST_DIR}/view/newscoremodel.h
    ${CMAKE_CURRENT_LIST_DIR}/view/additionalinfomodel.cpp
    ${CMAKE_CURRENT_LIST_DIR}/view/additionalinfomodel.h
    ${CMAKE_CURRENT_LIST_DIR}/view/scorethumbnail.cpp
    ${CMAKE_CURRENT_LIST_DIR}/view/scorethumbnail.h
    ${CMAKE_CURRENT_LIST_DIR}/view/templatesmodel.cpp
    ${CMAKE_CURRENT_LIST_DIR}/view/templatesmodel.h
    ${CMAKE_CURRENT_LIST_DIR}/view/templatepaintview.cpp
    ${CMAKE_CURRENT_LIST_DIR}/view/templatepaintview.h
    ${CMAKE_CURRENT_LIST_DIR}/view/exportdialogmodel.cpp
    ${CMAKE_CURRENT_LIST_DIR}/view/exportdialogmodel.h
    ${CMAKE_CURRENT_LIST_DIR}/internal/filescorecontroller.cpp
    ${CMAKE_CURRENT_LIST_DIR}/internal/filescorecontroller.h
    ${CMAKE_CURRENT_LIST_DIR}/internal/iplatformrecentfilescontroller.h
    ${CMAKE_CURRENT_LIST_DIR}/internal/userscoresconfiguration.cpp
    ${CMAKE_CURRENT_LIST_DIR}/internal/userscoresconfiguration.h
    ${CMAKE_CURRENT_LIST_DIR}/internal/userscoresservice.cpp
    ${CMAKE_CURRENT_LIST_DIR}/internal/userscoresservice.h
    ${CMAKE_CURRENT_LIST_DIR}/internal/itemplatesrepository.h
    ${CMAKE_CURRENT_LIST_DIR}/internal/templatesrepository.cpp
    ${CMAKE_CURRENT_LIST_DIR}/internal/templatesrepository.h
    ${CMAKE_CURRENT_LIST_DIR}/internal/userscoresuiactions.cpp
    ${CMAKE_CURRENT_LIST_DIR}/internal/userscoresuiactions.h
    ${CMAKE_CURRENT_LIST_DIR}/internal/exporttype.cpp
    ${CMAKE_CURRENT_LIST_DIR}/internal/exporttype.h
    ${CMAKE_CURRENT_LIST_DIR}/internal/exportscorescenario.cpp
    ${CMAKE_CURRENT_LIST_DIR}/internal/exportscorescenario.h
    ${PLATFORM_SRC}
    )

set(MODULE_LINK notation)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)

