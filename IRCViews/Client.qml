import QtQml 2.2
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

ColumnLayout {
	id: clientView

	property QtObject client;

	signal quit();

	JoinChannel {
		id: joinDialog
		onJoin: {client.sendMessage(["JOIN", channel]);}
	}

	ToolBar {
		Layout.fillWidth: true
		RowLayout {
			anchors.fill: parent

			ToolButton {
				text: "Disconnect"
				//iconName: "network-disconnect"
				onClicked: {client.sendMessage(["QUIT"]); quit();}
			}

			ToolButton {
				text: "Join channel"
				//iconName: "irc-join-channel"
				onClicked: joinDialog.open()
			}

			ToolButton {
				text: "Leave channel"
				//iconName: "irc-close-channel"
				onClicked: {tabs.getTab(tabs.currentIndex).conversationView.runUserCommand("/part");}
			}

			Item {
				Layout.fillWidth: true
			}
		}
	}

	function showConversation(name)
	{
		var conv = client.getConversation(name);
		for (var i = 0; i < tabs.count; ++i)
			if (tabs.getTab(i).conversation == conv)
				tabs.currentIndex = i;
	}

	TabView {
		id: tabs

		Layout.fillHeight: true
		Layout.fillWidth: true

		Repeater {
			model: clientView.client ? clientView.client.conversations : null

			Component {
				Tab {
					title: modelData.name
					Conversation {
						id: conv
						conversation: modelData
						client: clientView.client
					}
					property var conversationView: children[0]
					property var conversation: conversationView.conversation
				}
			}
		}

		onCountChanged: {
			currentIndex = count - 1
		}
	}
}
