import QtQml 2.2
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import net.lew21.IRC 1.0 as IRCCore
import net.lew21.IRCViews 1.0 as IRCViews

GridLayout {
	columns: 2

	property Component __Core: IRCCore.Client {}
	property Component __View: IRCViews.Client {
		onQuit: main.pop()
	}

	function login()
	{
		// View and IRC_Client will be destroyed automatically by pop().
		var view = main.push(__View);
		view.client = __Core.createObject(view, {hostname: hostnameField.text, port: portField.text, requestedNick: nickField.text});
	}

	Label {
		text: "Host:"
		Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
	}

	Row {
		TextField {
			id: hostnameField
			text: "localhost"
			width: 150
			onAccepted: login()
		}

		TextField {
			id: portField
			text: "6667"
			width: 50
			onAccepted: login()
		}
	}

	Label {
		text: "Nickname:"
		Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
	}

	TextField {
		id: nickField
		text: "guest" + Math.floor(Math.random()*1000)
		Layout.fillWidth: true
		onAccepted: login()
	}

	Button {
		Layout.columnSpan: 2
		Layout.alignment: Qt.AlignVCenter | Qt.AlignCenter
		text: "Connect"
		onClicked: login()
	}
}
