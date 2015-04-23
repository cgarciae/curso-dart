library mongo;

import "package:redstone/server.dart" as app;
import "package:redstone/query_map.dart";
import 'package:redstone_mapper/plugin.dart';
import 'package:taller/modelos/usuario.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:redstone_mapper_mongo/service.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';




















//DI

@app.Route ('/holaMongo', methods: const [app.POST])
@Encode()
holaMongo (@app.Attr() MongoDb dbConn, @Decode() Usuario user) async
{
  user.id = new ObjectId().toHexString();
  
  await dbConn.insert('usuarios', user);
  
  //Tambien accessible en:
  //app.request.attributes.dbConn;
  
  return user;
}





















//findOne

@app.Route ('/testFind/:id', methods: const [app.POST])
@Encode()
testFind (String id, @app.Attr() MongoDb dbConn) async
{
  var user = await dbConn.findOne('usuario', Usuario, {'_id': new ObjectId.fromHexString(id)});

  return user;
}














//where

@app.Route ('/testFind2/:id', methods: const [app.POST])
@Encode()
testFind2 (String id, @app.Attr() MongoDb dbConn) async
{
  var user = await dbConn.findOne(
    'usuario',
    Usuario,
    where.id(new ObjectId.fromHexString(id))
  );

  return user;
}


















//innerConn

@app.Route ('/testFindMongoDart/:id', methods: const [app.POST])
@Encode()
testFindMongoDart (String id, @app.Attr() MongoDb dbConn) async
{
  var data = await dbConn.innerConn.collection('usuario')
                                   .findOne(where.id(new ObjectId.fromHexString(id)));
  
  var user = dbConn.decode(data, Usuario);

  return user;
}





