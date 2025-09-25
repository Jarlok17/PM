// usermanager.hpp

#pragma once

#include <QObject>
#include <qqml.h>

#include "../dbmanager/dbmanager.hpp"

class UserManager : public QObject
{
        Q_OBJECT
        QML_ELEMENT
        Q_PROPERTY(int currentUserId READ currentUserId WRITE setCurrentUserId NOTIFY currentUserIdChanged)
    public:
        explicit UserManager(DBManager *dbManager, QObject *parent = nullptr);

        Q_INVOKABLE bool createUser(const QString &email, const QString &username, const QString &masterPasswordHash);
        Q_INVOKABLE bool authenticateUser(const QString &username, const QString &masterPasswordHash);
        Q_INVOKABLE bool userExists(const QString &username);
        Q_INVOKABLE QVariantMap getCurrentUser();

        Q_INVOKABLE bool isEmailValid(const QString &email);
        Q_INVOKABLE bool isPasswordValid(const QString &password);
        Q_INVOKABLE bool isUsernameValid(const QString &username);

        int currentUserId() const;
        Q_INVOKABLE void setCurrentUserId(int userId);

    signals:
        void currentUserIdChanged(int userId);
        void registrationSuccess();
        void registrationFailed(const QString &errorMessage);
        void authenticationSuccess();
        void authenticationFailed(const QString &errorMessage);

    private:
        QString hashPassword(const QString &password);

        DBManager *m_dbManager;
        int m_currentUserId;
};
