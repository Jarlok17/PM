#pragma once

#include <QAbstractListModel>
#include <QCryptographicHash>
#include <QDebug>
#include <QList>
#include <QObject>
#include <QString>
#include <QVariant>
#include <QVector>

#include "../dbmanager/dbmanager.hpp"

class Password
{
    public:
        Password(const QString &title = "", const QString &password = "", const QString &notes = "", const QString &category = "",
                 bool favorite = false, int id = -1, int userId = -1)
            : m_id(id)
            , m_userId(userId)
            , m_title(title)
            , m_password(password)
            , m_notes(notes)
            , m_category(category)
            , m_favorite(favorite)
        {
        }

        int id() const { return m_id; }
        int userId() const { return m_userId; }
        QString title() const { return m_title; }
        QString password() const { return m_password; }
        QString notes() const { return m_notes; }
        QString category() const { return m_category; }
        bool favorite() const { return m_favorite; }

        void setId(int id) { m_id = id; }
        void setUserId(int userId) { m_userId = userId; }
        void setTitle(const QString &title) { m_title = title; }
        void setPassword(const QString &password) { m_password = password; }
        void setNotes(const QString &notes) { m_notes = notes; }
        void setCategory(const QString &category) { m_category = category; }
        void setFavorite(bool favorite) { m_favorite = favorite; }

    private:
        int m_id;
        int m_userId;
        QString m_title;
        QString m_password;
        QString m_notes;
        QString m_category;
        bool m_favorite;
};

class PasswordManager : public QAbstractListModel
{
        Q_OBJECT
        QML_ELEMENT
        Q_PROPERTY(int currentUserId READ currentUserId WRITE setCurrentUserId NOTIFY currentUserIdChanged)

    public:
        enum PasswordRoles {
            IdRole = Qt::UserRole + 1,
            UserIdRole,
            TitleRole,
            PasswordRole,
            NotesRole,
            CategoryRole,
            FavoriteRole
        };

        explicit PasswordManager(DBManager *dbManager, QObject *parent = nullptr);

        // QAbstractListModel interface
        int rowCount(const QModelIndex &parent = QModelIndex()) const override;
        QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
        QHash<int, QByteArray> roleNames() const override;

        // Custom methods
        Q_INVOKABLE bool addPassword(const QString &title, const QString &password, const QString &notes = "",
                                     const QString &category = "", bool favorite = false);
        Q_INVOKABLE bool updatePassword(int id, const QString &title, const QString &password, const QString &notes = "",
                                        const QString &category = "", bool favorite = false);
        Q_INVOKABLE bool deletePassword(int id);
        Q_INVOKABLE void searchPasswords(const QString &searchTerm);
        Q_INVOKABLE QVariantMap getPassword(int id) const;
        Q_INVOKABLE QVariantList getAllPasswords() const;
        Q_INVOKABLE QVariantList getPasswordsByCategory(const QString &category) const;
        Q_INVOKABLE QVariantList getFavoritePasswords() const;
        Q_INVOKABLE QStringList getCategories() const;
        Q_INVOKABLE void setFilter(const QString &filterType, const QString &filterValue);

        Q_INVOKABLE void clearFilter();
        Q_INVOKABLE bool toggleFavorite(int id);

        // Encryption methods
        Q_INVOKABLE QString encryptPassword(const QString &password, const QString &key);
        Q_INVOKABLE QString decryptPassword(const QString &encryptedPassword, const QString &key) const;

        int currentUserId() const;
        void setCurrentUserId(int userId);

    signals:
        void currentUserIdChanged(int userId);
        void passwordAdded(bool success);
        void passwordUpdated(bool success);
        void passwordDeleted(bool success);
        void errorOccurred(const QString &errorMessage);
        void categoriesChanged();
        void searchRequested(const QString &searchTerm);

    private:
        void loadPasswords();
        void applyCurrentFilter();
        QString simpleEncryptDecrypt(const QString &data, const QString &key) const;

        DBManager *m_dbManager;
        int m_currentUserId;
        QString m_currentFilterType = "all";
        QString m_currentFilterValue = "";
        QString m_currentSearchTerm;

        QVector<Password> m_allPasswords; // all passwords without a filters
        QVector<Password> m_passwords;
};
