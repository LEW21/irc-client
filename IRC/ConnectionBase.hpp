#pragma once

#include <QObject>
#include <QTcpSocket>

class IRCConnectionBase: public QObject
{
	Q_OBJECT
	Q_PROPERTY(bool connected READ is_connected NOTIFY connectedChanged)

	QTcpSocket m_socket;

public:
	IRCConnectionBase()
	{
		QObject::connect(&m_socket, &QTcpSocket::connected, this, &IRCConnectionBase::connectedChanged);
		QObject::connect(&m_socket, &QTcpSocket::connected, this, &IRCConnectionBase::connected);
		QObject::connect(&m_socket, &QTcpSocket::disconnected, this, &IRCConnectionBase::connectedChanged);
		QObject::connect(&m_socket, &QTcpSocket::disconnected, this, &IRCConnectionBase::disconnected);
		QObject::connect(&m_socket, &QTcpSocket::readyRead, this, &IRCConnectionBase::onReadyRead);
	}

public slots:
	void connectToHost(const QString& hostname, int port)
	{
		m_socket.connectToHost(hostname, port);
	}

	void disconnectFromHost()
	{
		m_socket.disconnectFromHost();
	}

	void sendMessage(const QString& data)
	{
		m_socket.write(data.toUtf8());
	}

private:
	void onReadyRead()
	{
		while (m_socket.canReadLine())
		{
			char line[8096];
			auto len = m_socket.readLine(line, sizeof(line));
			emit message(QString::fromUtf8(line, len));
		}
	}

public:
	auto is_connected() const -> bool { return m_socket.state() == QAbstractSocket::ConnectedState; }

signals:
	void connectedChanged();

	void connected();
	void disconnected();

	void message(const QString& msg);
};
