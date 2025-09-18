// textclipboard.hpp
#pragma once

#include <QClipboard>
#include <QGuiApplication>
#include <QObject>
#include <qqml.h>

class TextClipboard : public QObject
{
        Q_OBJECT

        Q_PROPERTY(QString text MEMBER m_text NOTIFY textChanged)
        QML_ELEMENT

    public:
        TextClipboard(QObject *parent = nullptr) : QObject(parent), m_text(QString()), clipboard(QGuiApplication::clipboard()) {}

        Q_INVOKABLE void copy() const { clipboard->setText(m_text); }
        Q_INVOKABLE void copy(const QString &value) const { clipboard->setText(value); }

    signals:
        void textChanged();

    public:
        QString m_text;
        QClipboard *clipboard;
};
