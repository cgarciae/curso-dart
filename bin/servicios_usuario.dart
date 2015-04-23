import "package:redstone/server.dart" as app;
import "package:redstone/query_map.dart";
import 'package:redstone_mapper/plugin.dart';
import 'package:taller/modelos/usuario.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:redstone_mapper_mongo/service.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';

@app.Group ("/usuario")
@Encode()
class ServiciosUsuario extends MongoDbService<Usuario>
{
    ServiciosUsuario () : super ("usuario");
    
    @app.DefaultRoute (methods: const [app.POST])
    Nuevo () async
    {
        Usuario usuario = new Usuario()
          ..nombre = "Nombre"
          ..apellido = "Apellido"
          ..descripcion = "Descripcion";
        //Llenar objeto usuario
        
        usuario.id = new ObjectId().toHexString();
        
        await insert(usuario);
        
        return usuario;
    }
    
    @app.Route ("/:id")
    Future<Usuario> Get (String id) async
    {
        return findOne(where.id(new ObjectId.fromHexString(id)));
    }
    
    @app.Route ("/:id/nombre", methods: const [app.PUT])
    CambiarNombre (String id, @app.QueryParam() nombre) async
    {
      await mongoDb.update
      (
          collectionName,
          where.id(new ObjectId.fromHexString(id)),
          modify.set("nombre", nombre)
      );
      
      return "OK";
    }
    
    @app.Route ("/:id", methods: const [app.PUT])
    Actualizar (String id, @Decode() Usuario delta) async
    {
      await this.update
      (
          where.id(new ObjectId.fromHexString(id)),
          delta,
          override: false
      );
      
      return Get (id);
    }
    
    @app.Route ("/:id", methods: const [app.DELETE])
    Eliminar (String id) async
    {
      await this.remove
      (
          where.id(new ObjectId.fromHexString(id))
      );
      
      return "OK";
    }
    
    @app.Route ("/todos")
    Future<List<Usuario>> Todos () async
    {
        return find ();
    }
}
