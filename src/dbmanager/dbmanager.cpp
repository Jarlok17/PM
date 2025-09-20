// dbmanager.cpp
#include "dbmanager.hpp"
#include <QDebug>
#include <QDir>
#include <QStandardPaths>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlRecord>

DBManager::DBManager(QObject *parent) : QObject(parent)
{
    // Create database
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(getUserDatabasePath());

    if (!db.open()) {
        qDebug() << "Database error:" << db.lastError().text();
    } else {
        qDebug() << "Database opened successfully:" << getUserDatabasePath();
        initializeDatabase();
    }
}

QString DBManager::getUserDatabasePath()
{
    QString homePath = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);
    QDir dir(homePath + "/.pm");
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    return dir.filePath("pm.db");
}

bool DBManager::initializeDatabase()
{
    // Create users table
    QSqlQuery query1;
    if (!query1.exec("CREATE TABLE IF NOT EXISTS users ("
                     "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                     "username TEXT UNIQUE NOT NULL, "
                     "master_password_hash TEXT NOT NULL, "
                     "email TEXT NOT NULL)")) {
        qDebug() << "Failed to create users table:" << query1.lastError().text();
        return false;
    }

    // Create passwords table
    QSqlQuery query2;
    if (!query2.exec("CREATE TABLE IF NOT EXISTS passwords ("
                     "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                     "user_id INTEGER NOT NULL, "
                     "title TEXT NOT NULL, "
                     "password TEXT NOT NULL, "
                     "notes TEXT, "
                     "category TEXT, "
                     "favorite BOOLEAN DEFAULT 0, "
                     "created_at DATETIME DEFAULT CURRENT_TIMESTAMP, "
                     "updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, "
                     "FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE)")) {
        qDebug() << "Failed to create passwords table:" << query2.lastError().text();
        return false;
    }

    qDebug() << "All tables created successfully";
    return true;
}

bool DBManager::executePreparedQuery(const QString &query, const QVariantList &params)
{
    QSqlQuery sqlQuery;
    sqlQuery.prepare(query);

    for (const QVariant &param : params) {
        sqlQuery.addBindValue(param);
    }

    if (!sqlQuery.exec()) {
        qDebug() << "Error query: :" << sqlQuery.lastError().text();
        return false;
    }
    return true;
}

QVariantList DBManager::getPreparedQueryResults(const QString &query, const QVariantList &params)
{
    QVariantList results;
    QSqlQuery sqlQuery;
    sqlQuery.prepare(query);

    for (const QVariant &param : params) {
        sqlQuery.addBindValue(param);
    }

    if (sqlQuery.exec()) {
        while (sqlQuery.next()) {
            QVariantMap row;
            for (int i = 0; i < sqlQuery.record().count(); ++i) {
                row[sqlQuery.record().fieldName(i)] = sqlQuery.value(i);
            }
            results.append(row);
        }
    }

    return results;
}
