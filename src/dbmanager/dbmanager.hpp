// dbmanager.hpp
#pragma once

#include <QObject>
#include <QtSql/QSqlDatabase>
#include <qqml.h>

class DBManager : public QObject
{
        Q_OBJECT
        QML_ELEMENT

    public:
        explicit DBManager(QObject *parent = nullptr);

        Q_INVOKABLE QString getUserDatabasePath();
        Q_INVOKABLE bool initializeDatabase();
        Q_INVOKABLE bool executePreparedQuery(const QString &query, const QVariantList &params = QVariantList());
        Q_INVOKABLE QVariantList getPreparedQueryResults(const QString &query, const QVariantList &params = QVariantList());

    private:
        QSqlDatabase db;
};
