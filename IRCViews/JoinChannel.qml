import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2

Dialog {
	title: "Join channel"
	standardButtons: StandardButton.Ok | StandardButton.Cancel

	signal join(string channel);

	GridLayout {
		width: parent.width
		columns: 2

		Label {
			text: "Name:"
		}

		TextField {
			id: name
			Layout.fillWidth: true
			focus: true
			text: "#"
		}
	}

	onAccepted: { join(name.text); name.text = "#"; }
}
