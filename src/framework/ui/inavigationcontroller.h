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
#ifndef MUSE_UI_INAVIGATIONCONTROLLER_H
#define MUSE_UI_INAVIGATIONCONTROLLER_H

#include "modularity/imoduleinterface.h"
#include "inavigation.h"
#include "async/notification.h"

namespace muse::ui {
class INavigationController : MODULE_EXPORT_INTERFACE
{
    INTERFACE_ID(INavigationController)

public:
    virtual ~INavigationController() = default;

    virtual void reg(INavigationSection* section) = 0;
    virtual void unreg(INavigationSection* section) = 0;

    virtual bool requestActivateByName(const std::string& section, const std::string& panel, const std::string& controlName) = 0;
    virtual bool requestActivateByIndex(const std::string& section, const std::string& panel, const INavigation::Index& controlIndex) = 0;

    virtual void resetNavigation() = 0;

    virtual INavigationSection* activeSection() const = 0;
    virtual INavigationPanel* activePanel() const = 0;
    virtual INavigationControl* activeControl() const = 0;

    virtual const std::set<INavigationSection*>& sections() const = 0;
    virtual const INavigationSection* findSection(const std::string& sectionName) const = 0;
    virtual const INavigationPanel* findPanel(const std::string& sectionName, const std::string& panelName) const = 0;
    virtual const INavigationControl* findControl(const std::string& sectionName, const std::string& panelName,
                                                  const std::string& controlName) const = 0;

    virtual void setDefaultNavigationControl(INavigationControl* control) = 0;

    virtual async::Notification navigationChanged() const = 0;

    virtual bool isHighlight() const = 0;
    virtual void setIsHighlight(bool isHighlight) = 0;
    virtual async::Notification highlightChanged() const = 0;

    virtual void setIsResetOnMousePress(bool arg) = 0;

    virtual void dump() const = 0;
};
}

#endif // MUSE_UI_INAVIGATIONCONTROLLER_H
