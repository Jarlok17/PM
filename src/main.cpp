#include <QFile>
#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "clipboard/textclipboard.hpp"
#include "dbmanager/dbmanager.hpp"
#include "passwordmanager/passwordmanager.hpp"
#include "usermanager/usermanager.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setApplicationName("PM");
    app.setApplicationVersion("1.0.0");
    app.setOrganizationName("Zero");

#ifdef Q_OS_WIN
    QString iconPath = ":/icons/app/icon.ico";
#else
    QString iconPath = ":/icons/app/icon.png";
#endif

    qDebug() << "Loading icon from:" << iconPath;
    if (QFile::exists(iconPath)) {
        qDebug() << "Icon file exists";
        app.setWindowIcon(QIcon(iconPath));
    } else {
        qDebug() << "Icon file does NOT exist";
        iconPath = "qrc:/icons/app/icon.png";
        qDebug() << "Trying alternative path:" << iconPath;
        app.setWindowIcon(QIcon(iconPath));
    }

    QQmlApplicationEngine engine;

    engine.addImportPath("qrc:/");

    qmlRegisterType<TextClipboard>("PM", 1, 0, "TextClipboard");
    qmlRegisterType<DBManager>("PM", 1, 0, "DBManager");
    qmlRegisterType<UserManager>("PM", 1, 0, "UserManager");
    qmlRegisterType<PasswordManager>("PM", 1, 0, "PasswordManager");

    // Create managers
    DBManager dbManager;
    UserManager userManager(&dbManager);
    PasswordManager passwordManager(&dbManager);

    // Add them to context for global access
    engine.rootContext()->setContextProperty("dbManager", &dbManager);
    engine.rootContext()->setContextProperty("userManager", &userManager);
    engine.rootContext()->setContextProperty("passwordManager", &passwordManager);

    // Connect user manager to password manager
    QObject::connect(&userManager, &UserManager::currentUserIdChanged, &passwordManager, &PasswordManager::setCurrentUserId);

    const QUrl url(QStringLiteral("qrc:/Main.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
