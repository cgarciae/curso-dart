import 'package:redstone/server.dart' as app;
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mvc/redstone_mvc.dart' as mvc;
import 'package:rethinkdb_driver/rethinkdb_driver.dart';
import 'package:redstone_rethinkdb/redstone_rethinkdb.dart';
import 'dart:async';

main() async {
  RethinkDbManager manager = new RethinkDbManager("104.131.109.228", "arista");

  app.addPlugin(mvc.mvcPluggin);
  app.addPlugin(getMapperPlugin());
  app.addPlugin(rethinkPlugin(manager));
  app.setupConsoleLog();

  await setupRethink(new ConfigRethink(
      host: "104.131.109.228",
      port: 7272,
      db: "arista",
      tables: ["usuarios", "eventos", "vistas"]
  ));

  print("setup complete");

  await app.start(port: 9090);
}
final Rethinkdb r = new Rethinkdb();

class User {
  @Field() String id;
  @Field() String firstname;
  @Field() String lastname;
}

@mvc.ViewController('/form', template: '''
<form action="/rethink" method="POST">
  First name:<br>
  <input type="text" name="firstname" value="Mickey">
  <br>
  Last name:<br>
  <input type="text" name="lastname" value="Mouse">
  <br><br>
<input type="submit" value="Submit">
</form>
''')
form() => {};

@mvc.ViewController('/form2', template: '''
<form action="/rethink" method="POST">
  First name:<br>
  <input type="text" name="firstname" value="Mickey">
  <br>
  Last name:<br>
  <input type="text" name="lastname" value="Mouse">
  <br><br>
<input type="submit" value="Submit">
</form>
''')
form2() => {};

@mvc.DataController('/rethink',
    methods: const [app.POST], allowMultipartRequest: true)
rethink(@app.Attr("dbConn") Connection conn, @Decode(
    from: const [app.FORM]) User user) async {
  user.id = await r.uuid().run(conn);

  var resp = await r.table("usuarios").insert(encode(user)).run(conn);

  return user;
}

@mvc.ViewController('/all', template:
'''
{{#.}}
  <h3>{{lastname}}, {{firstname}}</h3>
  <p>{{id}}</p>
{{/.}}
''')
all(String id, @app.Attr("dbConn") Connection conn) async {
  return ((await r.table('usuarios').run(conn)) as Cursor).toArray();
}


@mvc.GroupController('/api/usuarios/v1')
class ServiciosUsuario extends RethinkServices<User> {
  ServiciosUsuario() : super('usuarios');

  @mvc.DataController('/:id')
  Future<User> GET(String id) async {
    User user = await getNow(id);
    if (user == null) throw new app.ErrorResponse(
        404, {"error": "User not found"});
    return user;
  }

  @mvc.DataController('/:id', methods: const [app.PUT])
  Future<User> PUT(
      String id, @Decode(from: const [app.JSON, app.FORM]) User delta) async {
    delta.id = null;

    Map resp = await updateNow(id, delta);

    if (resp['replaced'] == 0) throw new app.ErrorResponse(
        304, {"error": "User not in database"});

    return GET(id);
  }

  @mvc.DataController('/:id', methods: const [app.DELETE])
  Future<Map> DELETE(String id) async {
    Map resp = await deleteNow(id);
    if (resp['deleted'] == 0) throw new app.ErrorResponse(
        501, {"error": "User not in database"});

    return {"id": id};
  }

  @mvc.DefaultDataController(methods: const [app.POST])
  Future<User> POST(@Decode() User user) async {
    var resp = await insertNow(user);
    user.id = resp["generated_keys"].first;

    return user;
  }
}