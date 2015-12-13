import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import QtQml 2.2

Item {
	id: conversationView

	property QtObject conversation;
	property QtObject client;

	function runUserCommand(msg) // (string)
	{
		var components = msg.split(" ");

		var command = components.shift();
		switch (command)
		{
			case "/part":
				var channel = components.length ? components.shift() : conversation.name;
				client.sendMessage(["PART", channel].concat(components.length ? [components.join(" ")] : []))
				break;

			case "/j":
			case "/join":
				var channel = components.length ? components.shift() : conversation.name;
				client.sendMessage(["JOIN", channel].concat(components.length ? [components.join(" ")] : []))
				break;

			case "/m":
			case "/msg":
				var target = components.shift();
				client.getConversation(target).sendMessage(components.join(" "))
				break;

			case "/quit":
				client.sendMessage(["QUIT", components.join(" ")]);
				clientView.quit();
				break

			default:
				client.sendMessage([command.substring(1).toUpperCase()].concat(components))
				break
		}
	}

	function sendMessage(msg) // (string)
	{
		if (msg[0] == '/')
			return runUserCommand(msg);

		conversation.sendMessage(msg);
	}

	ColumnLayout {
		anchors.fill: parent

		SplitView {
			orientation: Qt.Horizontal
			Layout.fillHeight: true
			Layout.fillWidth: true

			TableView {
				id: tv
				alternatingRowColors: false
				headerVisible: false
				Layout.fillWidth: true
				Layout.minimumWidth: 200
				model: conversation.messages

				TableViewColumn {
					width: 150

					delegate: Item {
						property var message: model ? model.modelData : {origin: {nick: ""}, command: "", params: []}
						property var sender: message.origin.nick ? message.origin.nick : message.origin.service
						Text {
							anchors.verticalCenter: parent.verticalCenter
							anchors.right: parent.right
							anchors.rightMargin: 5
							color: styleData.textColor
							elide: styleData.elideMode
							text: ((message.command == "PRIVMSG") ? "<font color='#aaa'>&lt;</font>" : "") + "<strong>" + sender + "</strong>" + ((message.command == "PRIVMSG") ? "<font color='#aaa'>&gt;</font>" : "")
						}
					}
				}
				TableViewColumn {
					delegate: Item {
						property var message: model ? model.modelData : {origin: {nick: ""}, command: "", params: []}
						Text {
							anchors.verticalCenter: parent.verticalCenter
							color: styleData.textColor
							elide: styleData.elideMode
							text: {
								if (message.command == "JOIN")
									return "has joined the room." + (message.params[1] ? " (" + message.params[1] + ")" : "");

								if (message.command == "PART")
									return "has left the room." + (message.params[1] ? " (" + message.params[1] + ")" : "");

								if (message.command == "QUIT")
									return "has left the server." + (message.params[1] ? " (" + message.params[1] + ")" : "");

								if (message.command == "PRIVMSG")
									return message.params[1];

								if (message.command == "NICK")
									return "is now known as <strong>" + message.params[0] + "</strong>.";

								return "<strong>" + message.command + "</strong> " + message.params.join(" ");
							}
						}
					}
				}

				Component {
					id: newTimer

					Timer {
						running: false
					}
				}

				function setTimeout(callback, timeout) {
					var obj = newTimer.createObject(conversationView, {repeat: false, interval: timeout});
					obj.triggered.connect(callback);
					obj.triggered.connect(function(){obj.destroy();});
					obj.running = true;
					return obj;
				}

				onRowCountChanged: {
					var setContentY = function(){
						var contentY = tv.flickableItem.contentHeight - tv.flickableItem.height;
						if (contentY < 0)
							contentY = 0;
						tv.flickableItem.contentY = contentY;
					};

					setContentY();
					setTimeout(setContentY, 0);
				}
			}

			TableView {
				alternatingRowColors: false
				visible: conversation.type == "channel"
				headerVisible: false
				width: 200
				model: conversation.users

				TableViewColumn {
					role: "name"

					delegate: Item {
						property var name: model ? model.name : ""
						Menu {
							id: menu
							MenuItem {
								text: "Open conversation"
								onTriggered: {clientView.showConversation(name);}
							}
						}
						MouseArea {
							anchors.fill: parent
							acceptedButtons: Qt.RightButton
							Text {
								anchors.verticalCenter: parent.verticalCenter
								anchors.left: parent.left
								anchors.leftMargin: 5
								color: styleData.textColor
								elide: styleData.elideMode
								text: name
							}
							onClicked: menu.popup()
						}
					}
				}
			}
		}

		RowLayout {
			Layout.fillWidth: true

			TextField {
				width: 100
				Layout.minimumWidth: 50
				Layout.maximumWidth: 300
				text: client.currentNick

				onAccepted: {client.requestedNick = text;}
				onEditingFinished: {text = Qt.binding(function(){return client.currentNick;})}
			}

			TextField {
				Layout.fillWidth: true
				onAccepted: { if (text != "") sendMessage(text); text = ""; }
			}
		}
	}
}
