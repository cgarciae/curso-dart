
//QueryMap, permite utilizar un Map como si fuera un objeto de JS
import "package:redstone/query_map.dart";
//Pluggin para encode/decode JSON
import 'package:redstone_mapper/plugin.dart';
//class Usuario
import 'package:taller/modelos/usuario.dart';
//Pluggin de MongoDB para Redstone
import 'package:redstone_mapper_mongo/manager.dart';

//importar las rutas creadas en otros archivos para que redstone
//las active en "app.start"
import 'servicios_usuario.dart';
import 'mongo.dart';

//servir archivos staticos
import 'package:shelf_static/shelf_static.dart';























import "package:redstone/server.dart" as app;

main() 
{
  otherConfig();
  app.setupConsoleLog();
  app.start(port: 9090);
}


//GET :: /hello
@app.Route ("/hello")
String helloWorld () => "Hello, World!";

























@app.Route("/saludar/:nombre/:apellido")
String helloAlguien (String nombre, String apellido) => "Hola $nombre $apellido!";



























@app.Route("/saludar")
String helloAlguienConQuery (@app.QueryParam() String nombre, 
                             @app.QueryParam() String apellido) 
    => "Hola $nombre $apellido!";























//Forms


@app.Route(
  "/saludarFormQueryMap",
  methods: const [app.POST, app.PUT],
  allowMultipartRequest: true
)
String helloAlguienConFormMap (@app.Body(app.FORM) Map form) 
          => "Hola ${form['nombre']} ${form['apellido']}!";














//Con QueryMap, casi JS


@app.Route
(
    "/saludarForm", 
    methods: const [app.POST, app.PUT], 
    allowMultipartRequest: true
)
String helloAlguienConForm (@app.Body(app.FORM) QueryMap form) 
  => "Hola ${form.nombre} ${form.apellido}!";
















//JSON


@app.Route
(
    "/saludarJson", 
    methods: const [app.POST, app.PUT]
)
String helloAlguienJson (@app.Body(app.JSON) QueryMap form) 
  => "Hola ${form.nombre} ${form.apellido}!";




  
  
  
  
  
  











 
@app.Route
(
    "/saludarJsonMapper", 
    methods: const [app.POST, app.PUT]
)
@Encode()
Usuario helloAlguienJsonMapper (@Decode() Usuario user)
{
    user.clicks++;
    return user;
}

















@app.Interceptor(r'/.*')
handleResponseHeader()
{
    app.chain.next(() => app.response.change(headers: {'Cache-Control': 'private, no-store, no-cache, must-revalidate, max-age=0'}));
}


otherConfig()
{
    var dbManager = new MongoDbManager
    (
        r"mongodb://192.168.59.103:8095/taller3", poolSize: 3
    );
    
    app.addPlugin(getMapperPlugin(dbManager));
    //app.addPlugin(getMapperPlugin());
    
    
    app.setShelfHandler (createStaticHandler
    (
        "web", 
        defaultDocument: "index.html",
        serveFilesOutsidePath: true
    ));
}











