import "package:redstone/server.dart" as app;
import "package:redstone/query_map.dart";
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:taller/modelos/usuario.dart';
import 'package:taller/modelos/ref.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:redstone_mapper_mongo/service.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';
import 'core/db_service.dart';

@app.Group ("/usuario")
@Encode()
class ServiciosUsuario extends DbService<Usuario>
{
    ServiciosCommentarios serviciosCommentarios;
    
    ServiciosUsuario (this.serviciosCommentarios,
                      MongoConnection db) : super ("usuario", db);
    
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
//      await mongoDb.update
//      (
//          collectionName,
//          where.id(new ObjectId.fromHexString(id)),
//          modify.set("nombre", nombre)
//      );
      
//      this.collectionName;
//      this.find()
//      this.findOne()
//      this.insert(obj)
//      this.update(selector, obj)
//      this.mongoDb //dbConn
//      this.mongoDb.innerConn ==> Mongo Dart
      
      await update
      (
         where.id(new ObjectId.fromHexString(id)),
         new Usuario()
          ..nombre = nombre,
         override: false
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
      await remove
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

@app.Group ('/commentarios')
class ServiciosCommentarios
{
  @app.DefaultRoute ()
  Get (@app.QueryParam() String idUsuario)
  {
    //buscar todos los commentarios del usuario
    throw new UnimplementedError();
  }
}

class Commentario extends Ref
{
  @Field() Usuario propietario;
  @Field() String commentario;
}
