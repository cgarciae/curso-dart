library group;

import "package:redstone/server.dart" as app;
import "package:redstone/query_map.dart";
import 'package:redstone_mapper/plugin.dart';
import 'package:taller/modelos/usuario.dart';
import 'package:taller/modelos/ref.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:redstone_mapper_mongo/service.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/plugin.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:redstone_mapper_mongo/metadata.dart';
import 'dart:async';






//Group basico

@app.Group ('/group')
class API_1
{
  // /group/servicioA
  @app.Route ('/servicioA')
  String servicioA () => "A";
  
  @app.Route ('/servicioB')
  String servicioB () => "B";
}






//Group con DI

@app.Group ('/group2')
@Encode()
class API_2
{
  API_1 ap1;
  
  API_2 (this.ap1);
  
  @app.Route ('/muchas')
  servicioA (@app.QueryParam() String letra)
  {
    if (letra == "a")
      return new Iterable.generate(5)
        .map((_) => ap1.servicioA())
        .toList();
    else if (letra == "b")
      return new Iterable.generate(3)
        .map((_) => ap1.servicioB())
        .toList();
    else
      return ["letra no aceptada"];
  }
  
  
  @app.Route ('/servicioB')
  servicioB () => "B";
}












class Casa
{
  @Id() String id;
  @Field() int x;
  @Field() int y;
  @Field() int get metrosCuadrados => x != null && y != null ? x * y : null;
}


@app.Group ('/casa')
@Encode()
class ServiciosCasa extends MongoDbService<Casa>
{
  ServiciosCasa () : super ('casa');
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  //Crear neuva casa en la base de datos
  
  @app.DefaultRoute(methods: const[app.POST])
  Future<Casa> nueva () async 
  {
    var casa = new Casa()
      ..x = 10
      ..y = 15
      ..id = new ObjectId().toHexString();
    
    await insert (casa);
    
    return casa;
  }
  
  
  
  
  
  
  
  
  
  
  
  //buscar la casa en la base de datos
  
  @app.DefaultRoute(methods: const[app.GET])
  Future<Casa> get (@app.QueryParam() id) async 
  {
    return findOne (where.id(new ObjectId.fromHexString(id)));
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  //actualizar la casa en la base de datos
  
  @app.DefaultRoute(methods: const[app.PUT])
  Future<Casa> actualizar (@app.QueryParam() id,
                           @Decode() Casa delta) async 
  {
    //Evitar que cambien el id
    delta.id = null;
    //Actualizar casa
    await update(
      where.id(new ObjectId.fromHexString(id)),
      delta,
      override: false
    );
    
    return get (id);
  }
  
  
  
  
  
  
  
  
  
  
  
  @app.DefaultRoute(methods: const[app.DELETE])
  Future<String> borrar (@app.QueryParam() id) async 
  {
    //Borrar casa
    await remove(
      where.id(new ObjectId.fromHexString(id))
    );
    
    return "OK";
  }
}