#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "clipboard/textclipboard.hpp"
#include "dbmanager/dbmanager.hpp"
#include "usermanager/usermanager.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<TextClipboard>("PM", 1, 0, "TextClipboard");
    qmlRegisterType<DBManager>("PM", 1, 0, "DBManager");
    qmlRegisterType<UserManager>("PM", 1, 0, "UserManager");

    // Create managers
    DBManager dbManager;
    UserManager userManager(&dbManager);

    // Add them to context for global access
    engine.rootContext()->setContextProperty("dbManager", &dbManager);
    engine.rootContext()->setContextProperty("userManager", &userManager);

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
