library modelos.usuario;

import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper_mongo/metadata.dart';
import 'ref.dart';

class Usuario extends Ref
{
  //otro id
  @ReferenceId() String otroId;
  
  @Field() String nombre;
  @Field() String apellido;
  @Field() String descripcion;
  @Field() String urlImagen;
  
  @Field() int clicks = 0;
}