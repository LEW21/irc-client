import net.lew21.IRC 1.0

ConnectionBase {
	signal messageComponents(var prefix, var components);

	onMessage: {
		var raw_components = msg.trim().split(" ");

		var prefix = (raw_components[0][0] == ":") ? raw_components.shift().substring(1) : null;

		var components = [];

		while (raw_components.length && raw_components[0][0] != ':')
			components.push(raw_components.shift());

		if (raw_components.length)
			components.push(raw_components.join(" ").substring(1));

		messageComponents(prefix, components);
	}

	function sendMessageComponents(prefix, components)
	{
		var raw_prefix = prefix ? ":" + prefix + " " : "";

		var lastComponent = components.pop();
		sendMessage(raw_prefix + (components.length ? components.join(" ") + " " : "") + ":" + lastComponent + "\n");
	}
}
