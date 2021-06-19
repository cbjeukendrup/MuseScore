#ifndef CHORDSYMBOLSTYLEEDITOR_H
#define CHORDSYMBOLSTYLEEDITOR_H

#include <QObject>
#include <QAbstractListModel>
#include "engraving/libmscore/style.h"
#include "notation/internal/chordsymbolstylemanager.h"

class ChordSymbolStyleEditor : public QAbstractListModel
{
public:
    ChordSymbolStyleEditor();

    QVariant data(const QModelIndex& index, int role) const override;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;

private:
    enum RoleNames {
        StyleNameRole = Qt::UserRole + 1,
        FileRole
    };

    QList<Ms::ChordSymbolStyle> m_styles = {
        {"Standard","std"},
        {"Jazz","jazz"}
    };
    ChordSymbolStyleManager* styleManager;
};

#endif // CHORDSYMBOLSTYLEEDITOR_H
