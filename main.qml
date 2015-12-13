import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

ApplicationWindow {
	title: "redirc"
	width: 640
	height: 480
	visible: true

	StackView {
		id: main
		initialItem: login

		anchors.fill: parent
		Component {
			id: login

			Item {
				LoginForm {
					anchors.centerIn: parent
				}
			}
		}
	}
}
