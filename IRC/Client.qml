import QtQuick 2.0
import QtQml 2.2
import QtQml.Models 2.2

QtObject {
	id: data

	property string hostname: "irc.freenode.net"
	property int port: 6667

	property string requestedNick; // write-only
	property string currentNick; // read-only

	property var autojoinChannels: ["#lew21-irc-client"]

	property ListModel conversations: ListModel {} // modelData: Conversation

	function sendMessage(components) // (array)
	{
		__con.sendMessageComponents(null, components);
	}

	function getConversation(name) // (string) -> Conversation
	{
		var c = __conversations_by_name[name];
		if (!c)
		{
			c = __conversations_by_name[name] = __newConversation.createObject(data, {name: name, type: name[0] == "#" ? "channel" : null, __client: data});
			if (name == "!server")
				c.name = hostname
			conversations.append({modelData: c});
		}
		return c;
	}

	// private ------------------------------------------------------------

	property var __conversations_by_name: { return {}; }
	property Component __newConversation: Conversation {}

	property Connection __con: Connection {
		onConnected: {
			data.__handleConnected();
		}

		onMessageComponents: {
			data.__handleMessage(prefix, components);
		}
	}

	property bool __connected: false
	property bool __authed: false

	Component.onCompleted: __con.connectToHost(hostname, port)

	function __handleConnected() {
		__connected = true;
		__authed = false;
		sendMessage(["NICK", requestedNick]);
		sendMessage(["USER", requestedNick, "0", "*", requestedNick]);
	}

	function __parsePrefix(nuh)
	{
		var nu_h = nuh.split("@");
		var n_u = nu_h[0].split("!");
		var parsed = { nick: n_u[0], username: n_u[1], hostname: nu_h[1] };

		if (parsed.username === undefined && parsed.hostname === undefined)
			return { service: parsed.nick };
		else
			return parsed;
	}

	function __parseMessage(prefix, components)
	{
		return {
			origin: prefix ? __parsePrefix(prefix) : null,
			command: components.shift(),
			params: components
		};
	}

	function __handleMessage(prefix, components) {

		var msg = __parseMessage(prefix, components)

		if (msg.command == "001")
		{
			currentNick = msg.params[0];
			__authed = true;
			for (var i = 0; i < autojoinChannels.length; ++i)
				sendMessage(["JOIN", autojoinChannels[i]]);
		}

		if (msg.command == "353")
		{
			var channel_type = msg.params[1];
			var channel = msg.params[2];
			var users = msg.params[3].split(" ");
			var c = getConversation(channel);

			if (c.__clearUsersBeforeAdding)
				c.users.clear();
			c.__clearUsersBeforeAdding = false;

			for (var i = 0; i < users.length; ++i)
			{
				var name = users[i];
				if (name[0] == '@' || name[0] == '+')
					name = name.substring(1);
				c.users.append({name: name});
			}
		}

		if (msg.command == "366")
		{
			var channel = msg.params[1];
			var c = getConversation(channel);

			c.__clearUsersBeforeAdding = true;
		}

		if (msg.command == "NICK")
		{
			var oldNick = msg.origin.nick;
			var newNick = msg.params[0];
			if (currentNick == oldNick)
			{
				currentNick = newNick;
				getConversation("!server").__addMessage(msg);
			}

			for (var i = 0; i < conversations.count; ++i)
			{
				var c = conversations.get(i).modelData;
				if (c.name == oldNick)
				{
					c.name = newNick;
					c.__addMessage(msg);
				}
				else
				{
					for (var j = 0; j < c.users.count; ++j)
					{
						var u = c.users.get(j);
						if (u.name == oldNick)
						{
							c.users.setProperty(j, "name", newNick)
							c.__addMessage(msg);
							break;
						}
					}
				}
			}

			return;
		}

		if (msg.command == "PING")
		{
			sendMessage(["PONG", msg.params[0]].concat(msg.params));
			return;
		}

		var send_to = !__authed ? "!server" : (msg.params[0] != currentNick) ? msg.params[0] : msg.origin.service ? "!server" : msg.origin.nick;

		getConversation(send_to).__addMessage(msg);
	}

	onRequestedNickChanged: {
		if (!__connected)
			return;

		if (requestedNick == currentNick)
			return;

		sendMessage(["NICK", requestedNick]);
	}
}
