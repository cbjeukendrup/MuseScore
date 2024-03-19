#ifndef MU_PROJECT_QSMODEL_H
#define MU_PROJECT_QSMODEL_H

#include <QObject>

namespace mu::project {
class QSModel : public QObject
{
    Q_OBJECT
public:
    explicit QSModel(QObject* parent = nullptr);

    Q_INVOKABLE void run();
};
}

#endif // MU_PROJECT_QSMODEL_H
