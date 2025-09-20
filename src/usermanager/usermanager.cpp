#include "usermanager.hpp"
#include <QCryptographicHash>
#include <QRegularExpression>
#include <QRegularExpressionMatch>

UserManager::UserManager(DBManager *db, QObject *parent) : QObject(parent), m_currentUserId(-1), m_dbManager(db) {}

QString UserManager::hashPassword(const QString &password)
{
    QByteArray passwordData = password.toUtf8();
    QByteArray hash = QCryptographicHash::hash(passwordData, QCryptographicHash::Sha256);
    return QString(hash.toHex());
}

bool UserManager::isEmailValid(const QString &email)
{
    QRegularExpression regex("^[0-9a-zA-Z._%+-]+@[0-9a-zA-Z.-]+\\.[a-zA-Z]{2,6}$");
    return regex.match(email).hasMatch();
}

bool UserManager::isPasswordValid(const QString &password)
{
    if (password.length() < 8)
        return false;

    QRegularExpression hasDigit("\\d");
    QRegularExpression hasUpper("[A-Z]");
    QRegularExpression hasLower("[a-z]");

    return hasDigit.match(password).hasMatch() && hasUpper.match(password).hasMatch() && hasLower.match(password).hasMatch();
}

bool UserManager::isUsernameValid(const QString &username)
{
    QRegularExpression regex("^[a-zA-Z0-9_.]{3,20}$");
    return regex.match(username).hasMatch();
}
bool UserManager::createUser(const QString &email, const QString &username, const QString &masterPassword)
{
    // Check email
    if (!isEmailValid(email)) {
        qDebug() << "Invalid email: " << email;
        emit registrationFailed("incorrect format of email ");
        return false;
    }

    if (!isUsernameValid(username)) {
        qDebug() << "Invalid username: " << username;
        emit registrationFailed("username has to contains only letters, number, dot and emphasis (3-20 symbols)");
        return false;
    }

    if (!isPasswordValid(masterPassword)) {
        qDebug() << "Invalid password";
        emit registrationFailed("password has to contains 8 symbols, including numbers, upper and lower case latters");
        return false;
    }

    if (userExists(username)) {
        qDebug() << "User exist:" << username;
        emit registrationFailed("User with this username already exists");
        return false;
    }

    QString passwordHash = hashPassword(masterPassword);
    QString query = "INSERT INTO users (email, username, master_password_hash) VALUES (?, ?, ?)";

    bool success = m_dbManager->executePreparedQuery(query, {email, username, passwordHash});
    if (!success) {
        qDebug() << "Error creating user:" << username;
        emit registrationFailed("Error creating user");
    } else {
        emit registrationSuccess();
    }

    return success;
}

bool UserManager::authenticateUser(const QString &username, const QString &masterPassword)
{
    QString passwordHash = hashPassword(masterPassword);
    QString query = "SELECT id FROM users WHERE username = ? AND master_password_hash = ?";
    QVariantList results = m_dbManager->getPreparedQueryResults(query, {username, passwordHash});

    if (results.isEmpty()) {
        qDebug() << "Incorrect login details for:" << username;
        emit authenticationFailed("Incorrect username or password");
        return false;
    }

    int userId = results.first().toMap()["id"].toInt();
    setCurrentUserId(userId);
    qDebug() << "Successfuly login for:" << username << "ID:" << userId;
    emit authenticationSuccess();
    return true;
}

bool UserManager::userExists(const QString &username)
{
    QString query = "SELECT id FROM users WHERE username = ?";
    QVariantList results = m_dbManager->getPreparedQueryResults(query, {username});
    return !results.isEmpty();
}

QVariantMap UserManager::getCurrentUser()
{
    if (m_currentUserId == -1) {
        return QVariantMap();
    }

    QString query = "SELECT * FROM users WHERE id = ?";
    QVariantList results = m_dbManager->getPreparedQueryResults(query, {m_currentUserId});

    return results.isEmpty() ? QVariantMap() : results.first().toMap();
}

int UserManager::currentUserId() const { return m_currentUserId; }

void UserManager::setCurrentUserId(int userId)
{
    if (m_currentUserId != userId) {
        m_currentUserId = userId;
        emit currentUserIdChanged(userId);
    }
}
