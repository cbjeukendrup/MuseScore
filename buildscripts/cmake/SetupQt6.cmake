# SPDX-License-Identifier: GPL-3.0-only
# MuseScore-Studio-CLA-applies
#
# MuseScore Studio
# Music Composition & Notation
#
# Copyright (C) 2024 MuseScore Limited
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

# IOS_CONFIG_BUG
# We removed LinguistTools from this list, as it's not available on iOS.
# We removed PrintSupport because there's no real printing from iOS. Perhaps at some
# point when we will want to print to PDF, we may need it then.

set(qt_components
    Core
    Gui
    Widgets
    Network
    NetworkAuth
    Qml
    Quick
    QuickControls2
    QuickWidgets
    Xml
    Svg

    Core5Compat
)

set(QT_LIBRARIES
    Qt::Core
    Qt::Gui
    Qt::Widgets
    Qt::Network
    Qt::NetworkAuth
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
    Qt::QuickWidgets
    Qt::Xml
    Qt::Svg

    Qt::Core5Compat
)

if (NOT IOS)
    list(APPEND qt_components
        LinguistTools
        PrintSupport
    )

    list(APPEND QT_LIBRARIES
        Qt::PrintSupport
    )
endif()

if(NOT OS_IS_WASM)
    list(APPEND qt_components Concurrent)
    list(APPEND QT_LIBRARIES Qt::Concurrent)
endif()

if(OS_IS_LIN)
    list(APPEND qt_components DBus)
    list(APPEND QT_LIBRARIES Qt::DBus)
endif()

if (QT_ADD_STATEMACHINE)
    # Note: only used in ExampleView class.
    # When that class is removed, don't forget to remove this dependency.
    list(APPEND qt_components StateMachine)
    list(APPEND QT_LIBRARIES Qt::StateMachine)
endif()

if(QT_ADD_WEBSOCKET)
    list(APPEND qt_components WebSockets)
    list(APPEND QT_LIBRARIES Qt::WebSockets)
endif()

find_package(Qt6 REQUIRED COMPONENTS ${qt_components})

include(QtInstallPaths)

qt_standard_project_setup(REQUIRES 6.3 SUPPORTS_UP_TO 6.9)
