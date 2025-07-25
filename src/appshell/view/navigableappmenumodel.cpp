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
#include "navigableappmenumodel.h"

#include <QApplication>
#include <QWindow>
#include <QKeyEvent>

#include <private/qkeymapper_p.h>

#include "log.h"

using namespace mu::appshell;
using namespace muse::ui;
using namespace muse::uicomponents;

QSet<int> convertToSet(QList<int> keys)
{
    return QSet<int>(keys.cbegin(), keys.cend());
}

QSet<int> convertToSet(QList<QKeyCombination> keys)
{
    QSet<int> keyset;
    for (const auto& key : keys) {
        keyset << key.toCombined();
    }
    return keyset;
}

QSet<int> possibleKeys(QKeyEvent* keyEvent)
{
    QKeyEvent* correctedKeyEvent = keyEvent;
    //! NOTE: correct work only with alt modifier
    correctedKeyEvent->setModifiers(Qt::AltModifier);

    auto keys = QKeyMapper::possibleKeys(correctedKeyEvent);
    return convertToSet(keys);
}

QSet<int> possibleKeys(const QChar& keySymbol)
{
    QKeyEvent fakeKey(QKeyEvent::KeyRelease, Qt::Key_unknown, Qt::AltModifier, keySymbol);
    auto keys = QKeyMapper::possibleKeys(&fakeKey);

    return convertToSet(keys);
}

NavigableAppMenuModel::NavigableAppMenuModel(QObject* parent)
    : AppMenuModel(parent)
{
}

void NavigableAppMenuModel::load()
{
    AppMenuModel::load();

    connect(qApp, &QApplication::applicationStateChanged, this, [this](Qt::ApplicationState state){
        if (state != Qt::ApplicationActive) {
            resetNavigation();
        }
    });

    navigationController()->navigationChanged().onNotify(this, [this](){
        if (navigationController()->isHighlight() && !isMenuOpened()) {
            resetNavigation();
        }
    });

    qApp->installEventFilter(this);
}

void NavigableAppMenuModel::handleMenuItem(const QString& itemId)
{
    resetNavigation();
    restoreMUNavigationSystemState();

    AppMenuModel::handleMenuItem(itemId);
}

void NavigableAppMenuModel::openPrevMenu()
{
    navigate(Qt::Key_Left);
    activateHighlightedMenu();
}

void NavigableAppMenuModel::openNextMenu()
{
    navigate(Qt::Key_Right);
    activateHighlightedMenu();
}

void NavigableAppMenuModel::openMenu(const QString& menuId, bool byHover)
{
    bool navigationStarted = isNavigationStarted();
    bool menuIsAlreadyOpened = m_openedMenuId == menuId;
    if (!byHover && !menuIsAlreadyOpened) {
        if (navigationStarted || !isMenuOpened()) {
            saveMUNavigationSystemState();
        } else {
            restoreMUNavigationSystemState();
        }
    }

    if (navigationStarted) {
        setHighlightedMenuId(menuId);
    }

    emit openMenuRequested(menuId, byHover);
}

bool NavigableAppMenuModel::isNavigationStarted() const
{
    return !m_highlightedMenuId.isEmpty();
}

bool NavigableAppMenuModel::isMenuOpened() const
{
    return !m_openedMenuId.isEmpty();
}

QWindow* NavigableAppMenuModel::appWindow() const
{
    return m_appWindow;
}

void NavigableAppMenuModel::setAppWindow(QWindow* appWindow)
{
    m_appWindow = appWindow;
}

void NavigableAppMenuModel::setHighlightedMenuId(QString highlightedMenuId)
{
    if (m_highlightedMenuId == highlightedMenuId) {
        return;
    }

    m_highlightedMenuId = highlightedMenuId;
    emit highlightedMenuIdChanged(m_highlightedMenuId);
}

void NavigableAppMenuModel::setOpenedMenuId(QString openedMenuId)
{
    if (m_openedMenuId == openedMenuId) {
        return;
    }

    m_openedMenuId = openedMenuId;

    bool navigationStarted = isNavigationStarted();
    bool menuOpened = isMenuOpened();

    //! NOTE: When the user navigates through the menu, MU navigation is highlighted.
    //!       Reset the highlighted state after the menu is closed
    if (navigationStarted) {
        navigationController()->setIsHighlight(false);
    }

    //! NOTE: user closed menu by mouse
    if (!navigationStarted && !menuOpened) {
        restoreMUNavigationSystemState();
    }

    //! NOTE: after opening the menu, position on the first control
    if (navigationStarted && menuOpened) {
        actionsDispatcher()->dispatch("nav-first-control");
    }

    emit openedMenuIdChanged(m_openedMenuId);
}

void NavigableAppMenuModel::setAppMenuAreaRect(QRect appMenuAreaRect)
{
    if (m_appMenuAreaRect == appMenuAreaRect) {
        return;
    }

    m_appMenuAreaRect = appMenuAreaRect;
    emit appMenuAreaRectChanged(m_appMenuAreaRect);
}

void NavigableAppMenuModel::setOpenedMenuAreaRect(QRect openedMenuAreaRect)
{
    if (m_openedMenuAreaRect == openedMenuAreaRect) {
        return;
    }

    m_openedMenuAreaRect = openedMenuAreaRect;
    emit openedMenuAreaRectChanged(m_openedMenuAreaRect);
}

bool NavigableAppMenuModel::eventFilter(QObject* watched, QEvent* event)
{
    bool isMenuOpened = !m_openedMenuId.isEmpty();
    if (event->type() == QEvent::MouseButtonPress && watched == appWindow()) {
        QMouseEvent* mouseEvent = static_cast<QMouseEvent*>(event);
        bool clickOutsideAppMenuAreaRect = !m_appMenuAreaRect.contains(mouseEvent->pos());
        bool clickOutsideOpenedMenu = isMenuOpened ? !m_openedMenuAreaRect.contains(mouseEvent->pos()) : true;
        if (clickOutsideAppMenuAreaRect && clickOutsideOpenedMenu) {
            resetNavigation();
            emit closeOpenedMenuRequested();
            return false;
        }
    }

    if (isMenuOpened && watched && watched->isWindowType()) {
        return processEventForOpenedMenu(event);
    }

    if (watched == appWindow()) {
        bool ok = processEventForAppMenu(event);
        if (ok) {
            return ok;
        }
    }

    return AbstractMenuModel::eventFilter(watched, event);
}

bool NavigableAppMenuModel::processEventForOpenedMenu(QEvent* event)
{
    if (event->type() != QEvent::ShortcutOverride) {
        return false;
    }

    QKeyEvent* keyEvent = dynamic_cast<QKeyEvent*>(event);

    bool isNavigationWithSymbol = !keyEvent->modifiers()
                                  && keyEvent->text().length() == 1;

    if (!isNavigationWithSymbol || isNavigateKey(keyEvent->key())) {
        return false;
    }

    QChar symbol = keyEvent->text()[0];
    emit navigateWithSymbolRequested(symbol);
    event->accept();
    return true;
}

bool NavigableAppMenuModel::processEventForAppMenu(QEvent* event)
{
    QKeyEvent* keyEvent = dynamic_cast<QKeyEvent*>(event);
    if (!keyEvent) {
        return false;
    }

    Qt::KeyboardModifiers modifiers = keyEvent->modifiers();
    int key = keyEvent->key();
    bool isSingleSymbol = keyEvent->text().length() == 1;

    bool isNavigationStarted = this->isNavigationStarted();
    bool isNavigationWithSymbol = !modifiers
                                  && isSingleSymbol
                                  && isNavigationStarted;
    bool isNavigationWithAlt = (modifiers == Qt::AltModifier)
                               && isSingleSymbol;

    bool isAltKey = key == Qt::Key_Alt
                    && !(modifiers & Qt::ControlModifier)
                    && !(modifiers & Qt::ShiftModifier);

    switch (event->type()) {
    case QEvent::ShortcutOverride: {
        if (isNavigationStarted && isNavigateKey(key)) {
            event->accept();
            return true;
        } else if (isNavigationWithSymbol || isNavigationWithAlt) {
            QSet<int> activatePossibleKeys = possibleKeys(keyEvent);
            if (hasItem(activatePossibleKeys)) {
                event->accept();
                return true;
            }
        }

        m_needActivateHighlight = false;

        break;
    }
    case QEvent::KeyPress: {
        if (isAltKey) {
            m_needActivateHighlight = true;
            break;
        }

        m_needActivateHighlight = false;

        if (isNavigationStarted && isNavigateKey(key)) {
            navigate(key);

            event->accept();
            return true;
        } else if (isNavigationWithSymbol || isNavigationWithAlt) {
            QSet<int> activatePossibleKeys = possibleKeys(keyEvent);
            if (hasItem(activatePossibleKeys)) {
                navigate(activatePossibleKeys);

                event->accept();
                return true;
            }
        }

        break;
    }
    case QEvent::KeyRelease: {
        if (!isAltKey) {
            break;
        }

        if (isNavigationStarted) {
            resetNavigation();
            restoreMUNavigationSystemState();
        } else {
            if (m_needActivateHighlight) {
                m_needActivateHighlight = false;
                saveMUNavigationSystemState();
                navigateToFirstMenu();
            }
        }

        event->accept();
        return true;
    }
    case QEvent::MouseButtonPress: {
        resetNavigation();
        break;
    }
    default:
        break;
    }
    return false;
}

bool NavigableAppMenuModel::isNavigateKey(int key) const
{
    static const QList<Qt::Key> keys {
        Qt::Key_Left,
        Qt::Key_Right,
        Qt::Key_Down,
        Qt::Key_Space,
        Qt::Key_Escape,
        Qt::Key_Return,
        Qt::Key_Enter
    };

    return keys.contains(static_cast<Qt::Key>(key));
}

void NavigableAppMenuModel::navigate(int scanCode)
{
    Qt::Key _key = static_cast<Qt::Key>(scanCode);
    switch (_key) {
    case Qt::Key_Left: {
        int newIndex = itemIndex(m_highlightedMenuId) - 1;
        if (newIndex < 0) {
            newIndex = rowCount() - 1;
        }

        setHighlightedMenuId(item(newIndex).id());
        break;
    }
    case Qt::Key_Right: {
        int newIndex = itemIndex(m_highlightedMenuId) + 1;
        if (newIndex > rowCount() - 1) {
            newIndex = 0;
        }

        setHighlightedMenuId(item(newIndex).id());
        break;
    }
    case Qt::Key_Down:
    case Qt::Key_Space:
    case Qt::Key_Return:
    case Qt::Key_Enter:
        activateHighlightedMenu();
        break;
    case Qt::Key_Escape:
        resetNavigation();
        restoreMUNavigationSystemState();
        break;
    default:
        break;
    }
}

bool NavigableAppMenuModel::hasItem(const QSet<int>& activatePossibleKeys)
{
    return !menuItemId(items(), activatePossibleKeys).isEmpty();
}

void NavigableAppMenuModel::navigate(const QSet<int>& activatePossibleKeys)
{
    saveMUNavigationSystemState();

    setHighlightedMenuId(menuItemId(items(), activatePossibleKeys));
    activateHighlightedMenu();
}

void NavigableAppMenuModel::resetNavigation()
{
    setHighlightedMenuId("");
    m_needActivateHighlight = false;
}

void NavigableAppMenuModel::navigateToFirstMenu()
{
    setHighlightedMenuId(item(0).id());
}

QRect NavigableAppMenuModel::appMenuAreaRect() const
{
    return m_appMenuAreaRect;
}

QRect NavigableAppMenuModel::openedMenuAreaRect() const
{
    return m_openedMenuAreaRect;
}

void NavigableAppMenuModel::saveMUNavigationSystemState()
{
    if (m_lastActiveMUNavigationState.has_value()) {
        return;
    }

    bool muNavigationIsHighlight = navigationController()->isHighlight();
    m_needActivateLastMUNavigationControl = muNavigationIsHighlight;

    INavigationSection* section = navigationController()->activeSection();
    INavigationPanel* panel = navigationController()->activePanel();
    INavigationControl* control = navigationController()->activeControl();
    m_lastActiveMUNavigationState = {
        section ? section->name().toStdString() : "",
        panel ? panel->name().toStdString() : "",
        control ? control->name().toStdString() : ""
    };

    if (control) {
        control->setActive(false);
    }
}

void NavigableAppMenuModel::restoreMUNavigationSystemState()
{
    if (m_lastActiveMUNavigationState.has_value()) {
        MUNavigationSystemState state = m_lastActiveMUNavigationState.value();

        bool ok = navigationController()->requestActivateByName(state.sectionName, state.panelName, state.controlName);
        if (!ok) {
            navigationController()->resetNavigation();
        }

        m_lastActiveMUNavigationState.reset();
    }

    navigationController()->setIsHighlight(m_needActivateLastMUNavigationControl);
}

void NavigableAppMenuModel::activateHighlightedMenu()
{
    emit openMenuRequested(m_highlightedMenuId, false);
}

QString NavigableAppMenuModel::highlightedMenuId() const
{
    return m_highlightedMenuId;
}

QString NavigableAppMenuModel::openedMenuId() const
{
    return m_openedMenuId;
}

bool NavigableAppMenuModel::menuItemMatchesSymbol(MenuItem* menuItem, const QChar& symbol)
{
    QString title = menuItem->action().title.qTranslatedWithMnemonicAmpersand();

    int activateKeyIndex = title.indexOf('&');
    if (activateKeyIndex == -1) {
        return false;
    }

    auto keys = possibleKeys(symbol.toUpper());
    auto menuActivatePossibleKeys = possibleKeys(title[activateKeyIndex + 1].toUpper());
    if (menuActivatePossibleKeys.intersects(keys)) {
        return true;
    }

    return false;
}

QString NavigableAppMenuModel::menuItemId(const MenuItemList& items, const QSet<int>& activatePossibleKeys)
{
    for (const MenuItem* item : items) {
        QString title = item->action().title.qTranslatedWithMnemonicAmpersand();

        int activateKeyIndex = title.indexOf('&');
        if (activateKeyIndex == -1) {
            continue;
        }

        auto menuActivatePossibleKeys = possibleKeys(title[activateKeyIndex + 1].toUpper());
        if (menuActivatePossibleKeys.intersects(activatePossibleKeys)) {
            return item->id();
        }
    }

    return QString();
}
