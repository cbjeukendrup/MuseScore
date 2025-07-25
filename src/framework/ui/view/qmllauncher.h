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
#pragma once

#include <QObject>

#include "modularity/ioc.h"
#include "iinteractive.h"

namespace muse::ui {
class QmlLauncher : public QObject, public Injectable
{
    Q_OBJECT

    Inject<IInteractive> interactive = { this };

public:
    QmlLauncher(QObject* parent, const modularity::ContextPtr& iocCtx);

    Q_INVOKABLE bool open(const QString& uri);
    Q_INVOKABLE bool openApp(const QString& uri);
    Q_INVOKABLE bool openUrl(const QString& url);
};
}
