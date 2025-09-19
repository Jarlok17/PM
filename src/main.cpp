#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "clipboard/textclipboard.hpp"
#include "dbmanager/dbmanager.hpp"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<TextClipboard>("PM", 1, 0, "TextClipboard");

    DBManager dbManager;
    engine.rootContext()->setContextProperty("dbManager", &dbManager);

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
