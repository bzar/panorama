#include "pndscanner.h"

void PndScanner::scanPnds()
{
    QString configpath = pnd_conf_query_searchpath();
    QString appspath;
    QString overridespath;
    pnd_box_handle applist;
    pnd_conf_handle h;

    _pnds.clear();

    h = pnd_conf_fetch_by_id(pnd_conf_apps, configpath.toUtf8().data());
    if(h)
    {
        appspath = pnd_conf_get_as_char(h, (char *)PND_APPS_KEY);
        if(appspath.isEmpty())
            appspath = PND_APPS_SEARCHPATH;

        overridespath = pnd_conf_get_as_char(h, (char *)PND_PXML_OVERRIDE_KEY);
        if(overridespath.isEmpty())
            overridespath = PND_PXML_OVERRIDE_SEARCHPATH;
    }
    else
    {
        qWarning() << "Warning: No PND configuration file found. This means that application previews cannot be shown.";
        appspath = PND_APPS_SEARCHPATH;
        overridespath = PND_PXML_OVERRIDE_SEARCHPATH;
    }

    applist = pnd_disco_search(appspath.toUtf8().data(), overridespath.toUtf8().data());
    if(applist)
    {
        pnd_disco_t *discovery = (pnd_disco_t *)pnd_box_get_head(applist);
        Pnd translated;
        int clockspeed;
        bool ok;

        while(discovery)
        {
            translated.uid = discovery->unique_id;

            if(discovery->preview_pic1)
                translated.preview = discovery->preview_pic1;
            else if(discovery->preview_pic2)
                translated.preview = discovery->preview_pic2;
            else
                translated.preview = QString();

            clockspeed = QString(discovery->clockspeed).toInt(&ok, 10);
            if(ok)
                translated.clockspeed = clockspeed;
            else
                translated.clockspeed = 0;

            _pnds += translated;

            discovery = (pnd_disco_t *)pnd_box_get_next(discovery);
        }
    }
}

Pnd PndScanner::pndForUID(const QString &uid)
{
    foreach(const Pnd &pnd, _pnds)
    {
        if(pnd.uid == uid)
            return pnd;
    }
    return Pnd();
}

QList<Pnd> PndScanner::_pnds;
