
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone/server.dart' as app;
import 'package:redstone_mvc/redstone_mvc.dart' as mvc;
import 'package:redstone_utilities/redstone_utilities.dart';
import 'dart:math' as math;

main() {
  app.addPlugin(mvc.mvcPluggin);
  app.addPlugin(getMapperPlugin());

  app.setupConsoleLog();
  app.start(port: 9090);
}

@mvc.ViewController('/helloMvc', template: '<h1>{{text}}</h1>')
helloMvc() => {'text': 'Hello MVC!'};



















class Example {
  @Field() String title;
  @Field() String description;
}

@mvc.ViewController('/stringTemplate', template:
'''
  <div>
    <h2>{{title}}</h2>
    <p>{{description}}</p>
  </div>
''')
stringTemplate() => new Example()
  ..title = "MVC"
  ..description = "MVC is very easy with Redstone";









@mvc.ViewController('/fileTemplate', filePath: '/lib/template')
fileTemplate() {
  var example = new Example();
  example.title = "MVC!!!";
  example.description = "MVC is very easy with Redstone";

  return example;
}























@mvc.ViewController('/lib/template')
viewController() => new Example()
  ..title = "MVC"
  ..description = "MVC is very easy with Redstone";













  @mvc.ViewController ('/lib', subpath: '/template')
  subPath() => new Example()
    ..title = "Using subpath"
    ..description = "Just appends to the path";












@mvc.ViewController('/template', root: '/lib')
viewControllerRoot() => new Example()
  ..title = "MVC"
  ..description = "MVC is very easy with Redstone";














@mvc.GroupController('/info', root: '/lib')
class ExampleService1 {

  @mvc.ViewController ('/A')
  A () => new Example()
    ..title = "Route A"
    ..description = "Some description of A";

  @mvc.ViewController ('/B')
  B () => new Example()
    ..title = "Route B"
    ..description = "Some description of B";
}













@mvc.GroupController('/info2', root: '/lib')
class ExampleService2
{
  @mvc.ViewController ('/A', filePath: '/template')
  viewA () => new Example()
    ..title = "Route A"
    ..description = "Some description of A";

  @mvc.ViewController ('/B', filePath: '/template')
  viewB () => new Example()
    ..title = "Route B"
    ..description = "Some description of B";

  @mvc.ViewController ('/view', filePath: '/template', methods: const[app.POST], allowMultipartRequest: true)
  viewUpper (@Decode(from: const[app.FORM]) Example example) =>
    example
      ..title = example.title.toUpperCase()
      ..description = example.description.toUpperCase();

  @mvc.ViewController ('/form', filePath: '/form')
  form () => {};

  @mvc.DataController ('/json', methods: const[app.POST])
  jsonUpper (@Decode() Example example) => viewUpper(example);
}












//Model_StringTemplate, Model_Template

@mvc.ViewController ('/randomTemplate', root: '/lib/info')
dynamicFilePath ()
{
  var filePath = new math.Random().nextBool() ? '/A' : '/B';
  var model = new Example()
    ..title = "Dynamic File Path"
    ..description = 'If you return a Model_Path you can set the templates path dynamically';

  return new mvc.Model_Path(model, filePath);
}










//volver a "/info"