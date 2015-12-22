import qbs 1.0

Project {
	Product {
		name: "IRC"
		files: ["IRC/*.qml", "IRC/qmldir"]

		qbs.install: true
		qbs.installDir: "lib/qt/imports/net/lew21/IRC"
	}

	DynamicLibrary {
		name: "qmlircplugin"
		files: ["IRC/*.hpp"]
		//cpp.cxxLanguageVersion: "c++11"
		Depends { name: "Qt"; submodules: ["qml", "network"] }

		Group
		{
			fileTagsFilter: "dynamiclibrary"
			qbs.install: true
			qbs.installDir: "lib/qt/imports/net/lew21/IRC"
		}
	}

	Product {
		name: "IRCViews"
		files: ["IRCViews/*.qml", "IRCViews/qmldir"]

		qbs.install: true
		qbs.installDir: "lib/qt/imports/net/lew21/IRCViews"
	}

	Product {
		name: "App QML files"
		files: ["*.qml"]

		qbs.install: true
		qbs.installDir: "share/net.lew21.irc-client"
	}

	Application {
		name: "net.lew21.irc-client"
		files: ["*.cpp"]
		//cpp.cxxLanguageVersion: "c++11"
		Depends { name: "Qt"; submodules: ["gui", "quick", "widgets"] }

		Group
		{
			fileTagsFilter: "application"
			qbs.install: true
			qbs.installDir: "bin"
		}
	}
}
