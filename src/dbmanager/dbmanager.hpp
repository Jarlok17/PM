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
        Q_INVOKABLE bool executeQuery(const QString &query);
        Q_INVOKABLE QVariantList getQueryResults(const QString &query);

    private:
        QSqlDatabase db;
};
