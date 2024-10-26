/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-Studio-CLA-applies
 *
 * MuseScore Studio
 * Music Composition & Notation
 *
 * Copyright (C) 2024 MuseScore Limited
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

#include "undoredohistorymodel.h"

using namespace mu::notation;
using namespace muse;

UndoRedoHistoryModel::UndoRedoHistoryModel(QObject* parent)
    : QAbstractListModel(parent), Injectable(iocCtxForQmlObject(this))
{
}

void UndoRedoHistoryModel::load()
{
    emit currentActionIndexChanged();
}

QVariant UndoRedoHistoryModel::data(const QModelIndex& index, int role) const
{
    int row = index.row();
    if (row < 0 || row >= rowCount()) {
        return {};
    }

    size_t actionIndex = rowIndexToActionIndex(row);

    switch (role) {
    case ActionNameRole:
        return undoRedoActionNameAtActionIdx(actionIndex);
    default:
        return {};
    }
}

int UndoRedoHistoryModel::rowCount(const QModelIndex&) const
{
    return static_cast<int>(undoRedoActionCount());
}

QHash<int, QByteArray> UndoRedoHistoryModel::roleNames() const
{
    return {
        { ActionNameRole, "actionName" },
    };
}

int UndoRedoHistoryModel::currentActionRowIndex() const
{
    return actionIndexToRowIndex(undoRedoActionCurrentIdx());
}

INotationUndoStackPtr UndoRedoHistoryModel::undoStack() const
{
    INotationPtr notation = context()->currentNotation();
    return notation ? notation->undoStack() : nullptr;
}

size_t UndoRedoHistoryModel::undoRedoActionCount() const
{
    if (auto stack = undoStack()) {
        return stack->undoRedoActionCount();
    }

    return 0;
}

size_t UndoRedoHistoryModel::undoRedoActionCurrentIdx() const
{
    if (auto stack = undoStack()) {
        return stack->undoRedoActionCurrentIdx();
    }

    return muse::nidx;
}

QString UndoRedoHistoryModel::undoRedoActionNameAtActionIdx(size_t idx) const
{
    if (auto stack = undoStack()) {
        return stack->undoRedoActionNameAtIdx(idx).qTranslated();
    }

    return {};
}

int UndoRedoHistoryModel::actionIndexToRowIndex(size_t idx) const
{
    if (idx == muse::nidx || idx >= undoRedoActionCount()) {
        return -1;
    }

    return static_cast<int>(undoRedoActionCount() - 1 - idx);
}

int UndoRedoHistoryModel::rowIndexToActionIndex(int row) const
{
    if (row < 0 || row >= rowCount()) {
        return -1;
    }

    return undoRedoActionCount() - 1 - static_cast<size_t>(row);
}
