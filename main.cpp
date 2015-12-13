#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDir>

int main(int argc, char** argv)
{
	QApplication app{argc, argv};

	auto appPath = QDir{app.applicationDirPath()};
	auto importsPath = appPath.filePath("../lib/qt/imports");

	QQmlApplicationEngine engine;
	engine.addImportPath(importsPath);
	engine.load(appPath.filePath("../share/net.lew21.irc-client/main.qml"));

	return app.exec();
}
