library components.perfil;

//AndroidC: dart1234

import 'package:angular/angular.dart';
import 'package:taller/modelos/usuario.dart';
import 'dart:html' as dom;
import 'package:redstone_mapper/mapper.dart';

@Component
(
    selector: 'perfil',
    templateUrl: 'perfil.html' 
)
class Perfil
{
  List<Usuario> usuarios = [];
  
  @NgAttr("nombre") String nombre;
  @NgAttr("apellido") String apellido;
  
  Perfil ()
  {
    init();
  }
  
  init () async
  {
    var json = await dom.HttpRequest.getString("/usuario/todos");
    usuarios = decodeJson(json, Usuario);
  }
  
  nuevoUsuario () async
  {
    //Crear request
    var request = await dom.HttpRequest.request
    (
        "/usuario", method: "POST"
    );
    
    //Parse json
    Usuario nuevo = decodeJson(request.responseText, Usuario);
    
    //Agregar a la lista
    usuarios.add(nuevo);
    
  }
  
  actualizarUsuario (Usuario usuario) async
  {
    var json = encodeJson(usuario);
    await dom.HttpRequest.request
    (
        "/usuario/${usuario.id}",
        method: "PUT",
        sendData: json,
        requestHeaders: {"Content-Type": "application/json"}
    );
  }
  
  borrarUsuario (Usuario usuario) async
  {
    //borrar del servidor
    
    //borrar de la lista local
    usuarios.remove(usuario);
  }
  
  mayus (Usuario usuario)
  {
    usuario.descripcion = usuario.descripcion.toUpperCase();
    usuario.clicks += 3;
  }
  
  minus (Usuario usuario)
  {
      usuario.descripcion = usuario.descripcion.toLowerCase();
      usuario.clicks -= 3;
  }
  
}