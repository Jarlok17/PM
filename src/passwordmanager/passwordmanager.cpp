#include "passwordmanager.hpp"

PasswordManager::PasswordManager(DBManager *dbManager, QObject *parent)
    : QAbstractListModel(parent)
    , m_dbManager(dbManager)
    , m_currentUserId(-1)
{
    if (m_dbManager) {
        loadPasswords();
    }
}

int PasswordManager::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_passwords.size();
}

QVariant PasswordManager::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_passwords.size())
        return QVariant();

    const Password &password = m_passwords.at(index.row());

    switch (role) {
    case IdRole:
        return password.id();
    case UserIdRole:
        return password.userId();
    case TitleRole:
        return password.title();
    case PasswordRole:
        return password.password();
    case NotesRole:
        return password.notes();
    case CategoryRole:
        return password.category();
    case FavoriteRole:
        return password.favorite();
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> PasswordManager::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[UserIdRole] = "userId";
    roles[TitleRole] = "title";
    roles[PasswordRole] = "password";
    roles[NotesRole] = "notes";
    roles[CategoryRole] = "category";
    roles[FavoriteRole] = "favorite";
    return roles;
}

bool PasswordManager::addPassword(const QString &title, const QString &password, const QString &notes, const QString &category,
                                  bool favorite)
{
    if (m_currentUserId == -1) {
        emit errorOccurred("No user logged in");
        return false;
    }

    // Encrypt the password before storing
    QString encryptedPassword = encryptPassword(password, QString::number(m_currentUserId));

    QString query = "INSERT INTO passwords (user_id, title, password, notes, category, favorite) "
                    "VALUES (?, ?, ?, ?, ?, ?)";

    bool success = m_dbManager->executePreparedQuery(query, {m_currentUserId, title, encryptedPassword, notes, category, favorite});

    if (success) {
        // Get the ID of the newly inserted password
        QString getIdQuery = "SELECT last_insert_rowid() as id";
        QVariantList results = m_dbManager->getPreparedQueryResults(getIdQuery);

        if (!results.isEmpty()) {
            int newId = results.first().toMap()["id"].toInt();

            // Create new password
            Password newPassword(title, encryptedPassword, notes, category, favorite, newId, m_currentUserId);

            // Add to all passwords list
            m_allPasswords.append(newPassword);

            // Apply current filter to update visible list
            applyCurrentFilter();

            // Emit signal for model update
            QModelIndex index = createIndex(m_passwords.size() - 1, 0);
            emit dataChanged(index, index);
        }

        emit passwordAdded(true);
        emit categoriesChanged(); // Emit signal for categories update

        qDebug() << "Password added successfully. Total passwords:" << m_allPasswords.size();
    } else {
        emit errorOccurred("Failed to add password");
        emit passwordAdded(false);
    }

    return success;
}

bool PasswordManager::updatePassword(int id, const QString &title, const QString &password, const QString &notes,
                                     const QString &category, bool favorite)
{
    if (m_currentUserId == -1) {
        emit errorOccurred("No user logged in");
        return false;
    }

    // Encrypt the password before storing
    QString encryptedPassword = encryptPassword(password, QString::number(m_currentUserId));

    QString query = "UPDATE passwords SET title = ?, password = ?, notes = ?, category = ?, favorite = ? "
                    "WHERE id = ? AND user_id = ?";

    bool success =
        m_dbManager->executePreparedQuery(query, {title, encryptedPassword, notes, category, favorite, id, m_currentUserId});

    if (success) {
        // Update our local list
        for (int i = 0; i < m_passwords.size(); ++i) {
            if (m_passwords[i].id() == id) {
                m_passwords[i].setTitle(title);
                m_passwords[i].setPassword(encryptedPassword);
                m_passwords[i].setNotes(notes);
                m_passwords[i].setCategory(category);
                m_passwords[i].setFavorite(favorite);

                QModelIndex index = createIndex(i, 0);
                emit dataChanged(index, index);
                break;
            }
        }

        emit passwordUpdated(true);
    } else {
        emit errorOccurred("Failed to update password");
        emit passwordUpdated(false);
    }

    return success;
}

bool PasswordManager::deletePassword(int id)
{
    if (m_currentUserId == -1) {
        emit errorOccurred("No user logged in");
        return false;
    }

    QString query = "DELETE FROM passwords WHERE id = ? AND user_id = ?";
    bool success = m_dbManager->executePreparedQuery(query, {id, m_currentUserId});

    if (success) {
        // Remove from filtered list with proper model notification
        for (int i = 0; i < m_passwords.size(); ++i) {
            if (m_passwords[i].id() == id) {
                beginRemoveRows(QModelIndex(), i, i);
                m_passwords.remove(i);
                endRemoveRows();
                break;
            }
        }

        // Remove from all passwords list
        for (int i = 0; i < m_allPasswords.size(); ++i) {
            if (m_allPasswords[i].id() == id) {
                m_allPasswords.remove(i);
                break;
            }
        }

        emit passwordDeleted(true);
        emit categoriesChanged(); // Emit signal for categories update

        qDebug() << "Password deleted successfully. Total passwords:" << m_allPasswords.size();
    } else {
        emit errorOccurred("Failed to delete password");
        emit passwordDeleted(false);
    }

    return success;
}

void PasswordManager::searchPasswords(const QString &searchTerm)
{
    beginResetModel();
    m_passwords.clear();

    if (searchTerm.isEmpty()) {
        m_passwords = m_allPasswords;
    } else {
        QString lowerSearchTerm = searchTerm.toLower();

        for (const Password &password : m_allPasswords) {
            if (password.title().toLower().contains(lowerSearchTerm) || password.notes().toLower().contains(lowerSearchTerm)) {
                m_passwords.append(password);
            }
        }
    }

    endResetModel();
    emit searchRequested(searchTerm);
}

QVariantMap PasswordManager::getPassword(int id) const
{
    for (const Password &password : m_passwords) {
        if (password.id() == id) {
            QVariantMap result;
            result["id"] = password.id();
            result["userId"] = password.userId();
            result["title"] = password.title();
            result["password"] = decryptPassword(password.password(), QString::number(password.userId()));
            result["notes"] = password.notes();
            result["category"] = password.category();
            result["favorite"] = password.favorite();
            return result;
        }
    }

    return QVariantMap();
}

QVariantList PasswordManager::getAllPasswords() const
{
    QVariantList result;

    for (const Password &password : m_passwords) {
        QVariantMap item;
        item["id"] = password.id();
        item["userId"] = password.userId();
        item["title"] = password.title();
        item["password"] = decryptPassword(password.password(), QString::number(password.userId()));
        item["notes"] = password.notes();
        item["category"] = password.category();
        item["favorite"] = password.favorite();
        result.append(item);
    }

    return result;
}

QVariantList PasswordManager::getPasswordsByCategory(const QString &category) const
{
    QVariantList result;

    for (const Password &password : m_passwords) {
        if (password.category() == category) {
            QVariantMap item;
            item["id"] = password.id();
            item["userId"] = password.userId();
            item["title"] = password.title();
            item["password"] = decryptPassword(password.password(), QString::number(password.userId()));
            item["notes"] = password.notes();
            item["category"] = password.category();
            item["favorite"] = password.favorite();
            result.append(item);
        }
    }

    return result;
}

QVariantList PasswordManager::getFavoritePasswords() const
{
    QVariantList result;

    for (const Password &password : m_passwords) {
        if (password.favorite()) {
            QVariantMap item;
            item["id"] = password.id();
            item["userId"] = password.userId();
            item["title"] = password.title();
            item["password"] = decryptPassword(password.password(), QString::number(password.userId()));
            item["notes"] = password.notes();
            item["category"] = password.category();
            item["favorite"] = password.favorite();
            result.append(item);
        }
    }

    return result;
}

void PasswordManager::applyCurrentFilter()
{
    beginResetModel();
    m_passwords.clear();

    QVector<Password> filteredPasswords;

    if (m_currentFilterType == "favorites") {
        for (const Password &password : m_allPasswords) {
            if (password.favorite()) {
                filteredPasswords.append(password);
            }
        }
    } else if (m_currentFilterType == "category" && !m_currentFilterValue.isEmpty()) {
        for (const Password &password : m_allPasswords) {
            if (password.category() == m_currentFilterValue) {
                filteredPasswords.append(password);
            }
        }
    } else {
        filteredPasswords = m_allPasswords;
    }

    if (!m_currentSearchTerm.isEmpty()) {
        QString lowerSearchTerm = m_currentSearchTerm.toLower();
        for (const Password &password : filteredPasswords) {
            if (password.title().toLower().contains(lowerSearchTerm) || password.notes().toLower().contains(lowerSearchTerm)) {
                m_passwords.append(password);
            }
        }
    } else {
        m_passwords = filteredPasswords;
    }

    endResetModel();
}

void PasswordManager::setFilter(const QString &filterType, const QString &filterValue)
{
    m_currentFilterType = filterType;
    m_currentFilterValue = filterValue;
    applyCurrentFilter();
}

void PasswordManager::clearFilter()
{
    m_currentFilterType = "all";
    m_currentFilterValue = "";
    m_currentSearchTerm = "";
    applyCurrentFilter();
}

bool PasswordManager::toggleFavorite(int id)
{
    bool foundInFiltered = false;
    bool foundInAll = false;
    int filteredIndex = -1;
    int allIndex = -1;

    for (int i = 0; i < m_passwords.size(); ++i) {
        if (m_passwords[i].id() == id) {
            foundInFiltered = true;
            filteredIndex = i;
            break;
        }
    }

    for (int i = 0; i < m_allPasswords.size(); ++i) {
        if (m_allPasswords[i].id() == id) {
            foundInAll = true;
            allIndex = i;
            break;
        }
    }

    if (!foundInAll) {
        qDebug() << "Password with id" << id << "not found in all passwords list";
        return false;
    }

    bool newFavorite = !m_allPasswords[allIndex].favorite();

    QString query = "UPDATE passwords SET favorite = ? WHERE id = ? AND user_id = ?";
    bool success = m_dbManager->executePreparedQuery(query, {newFavorite, id, m_currentUserId});

    if (success) {
        m_allPasswords[allIndex].setFavorite(newFavorite);

        if (foundInFiltered) {
            m_passwords[filteredIndex].setFavorite(newFavorite);
            QModelIndex index = createIndex(filteredIndex, 0);
            emit dataChanged(index, index);
        }

        if (m_currentFilterType == "favorites" && !newFavorite) {
            applyCurrentFilter();
        }

        emit categoriesChanged();

        return true;
    }

    return false;
}

QString PasswordManager::encryptPassword(const QString &password, const QString &key)
{
    // Simple XOR encryption (in a real app, use a proper encryption library)
    return simpleEncryptDecrypt(password, key);
}

QString PasswordManager::decryptPassword(const QString &encryptedPassword, const QString &key) const
{
    // Simple XOR decryption (in a real app, use a proper encryption library)
    return simpleEncryptDecrypt(encryptedPassword, key);
}

int PasswordManager::currentUserId() const { return m_currentUserId; }

void PasswordManager::setCurrentUserId(int userId)
{
    if (m_currentUserId != userId) {
        m_currentUserId = userId;
        loadPasswords();
        emit currentUserIdChanged(userId);
    }
}

void PasswordManager::loadPasswords()
{
    beginResetModel();
    m_allPasswords.clear();
    m_passwords.clear();

    if (m_currentUserId == -1) {
        endResetModel();
        return;
    }

    QString query = "SELECT * FROM passwords WHERE user_id = ?";
    QVariantList results = m_dbManager->getPreparedQueryResults(query, {m_currentUserId});

    for (const QVariant &result : results) {
        QVariantMap row = result.toMap();
        Password password(row["title"].toString(), row["password"].toString(), row["notes"].toString(), row["category"].toString(),
                          row["favorite"].toBool(), row["id"].toInt(), row["user_id"].toInt());
        m_allPasswords.append(password);
    }

    m_passwords = m_allPasswords;
    endResetModel();
    emit categoriesChanged();
}

QStringList PasswordManager::getCategories() const
{
    QSet<QString> categories;
    for (const Password &password : m_allPasswords) {
        if (!password.category().isEmpty()) {
            categories.insert(password.category());
        }
    }
    return categories.values();
}

QString PasswordManager::simpleEncryptDecrypt(const QString &data, const QString &key) const
{
    // Simple XOR encryption/decryption
    // Note: This is not secure for production use!
    QString result;
    int keyIndex = 0;

    for (int i = 0; i < data.length(); ++i) {
        QChar encryptedChar = QChar(data[i].unicode() ^ key[keyIndex % key.length()].unicode());
        result.append(encryptedChar);
        keyIndex++;
    }

    return result;
}
