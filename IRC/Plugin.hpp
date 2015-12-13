#pragma once

#include <QQmlExtensionPlugin>
#include <QtQml>
#include "ConnectionBase.hpp"

class IRCPlugin : public QQmlExtensionPlugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
	void registerTypes(const char *uri)
	{
		Q_ASSERT(uri == QLatin1String("net.lew21.IRC"));
		qmlRegisterType<IRCConnectionBase>(uri, 1, 0, "ConnectionBase");
	}
};
