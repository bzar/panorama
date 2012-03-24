#ifndef PANDORAEVENTLISTENER_H
#define PANDORAEVENTLISTENER_H

#include "panoramainternal.h"
#include <QThread>

class PandoraEventListenerPrivate;

class PandoraEventListener : public QThread
{
    Q_OBJECT
    Q_PROPERTY(bool isActive READ isActive NOTIFY isActiveChanged)
    PANORAMA_DECLARE_PRIVATE(PandoraEventListener)
public:
    explicit PandoraEventListener(QObject *parent = 0);
    ~PandoraEventListener();

    bool isActive();

signals:
    void isActiveChanged(const bool value);
    void newEvent(const int state);

protected:
    void run();

};

class PandoraEventReader : public QObject
{
  Q_OBJECT
public:
  explicit PandoraEventReader(QObject *parent = 0);

signals:
    void newEvent(const int state);

private slots:
    void readEvent();

private:
    unsigned int prevButtons;
};

#endif // PANDORAEVENTLISTENER_H
