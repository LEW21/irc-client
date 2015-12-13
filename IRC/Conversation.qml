import QtQml 2.2
import QtQml.Models 2.2

QtObject {
	property string type;
	property string name;
	property ListModel messages: ListModel {} // modelData: {origin: {}, command: "", params: []}
	property ListModel users: ListModel {} // name: ""

	function sendMessage(msg) // (string)
	{
		__client.sendMessage(["PRIVMSG", name, msg]);
		__addMessage({
			origin: {nick: __client.currentNick},
			command: "PRIVMSG",
			params: [name, msg]
		});
	}

	// private ------------------------------------------------------------

	property QtObject __client;

	function __addMessage(msg)
	{
		messages.append({modelData: msg})

		if (msg.command == "QUIT" || msg.command == "PART")
			for (var i = 0; i < users.count; ++i)
				if (msg.origin.nick == users.get(i).name)
					users.remove(i, 1);

		if (msg.command == "JOIN")
			users.append({"name": msg.origin.nick});
	}

	property bool __clearUsersBeforeAdding: true;
}
