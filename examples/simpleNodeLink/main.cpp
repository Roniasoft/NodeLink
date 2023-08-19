#include <QtGui/QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QSurfaceFormat>

int main(int argc, char* argv[])
{
  QGuiApplication app(argc, argv);
  QQmlApplicationEngine engine;

  // Modify the default QSurfaceFormat to enhance shape smoothness without sacrificing performance.
  auto fmt = QSurfaceFormat::defaultFormat();
  fmt.setSamples(8);
  QSurfaceFormat::setDefaultFormat(fmt);

  // Set style into app.
  QQuickStyle::setStyle("Material");

  //Import all items into QML engine.
  engine.addImportPath(":/");

  const QUrl url(u"qrc:/simpleNodeLink/main.qml"_qs);
  QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                   &app, [url](QObject *obj, const QUrl &objUrl) {
      if (!obj && url == objUrl)
          QCoreApplication::exit(-1);
  }, Qt::QueuedConnection);
  engine.load(url);

  return app.exec();
}

