library modelos.usuario;

import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper_mongo/metadata.dart';

class Usuario
{
  @Id() String id;
  
  @Field() String nombre;
  @Field() String apellido;
  @Field() String descripcion;
  @Field() String urlImagen;
  
  @Field() int clicks = 0;
}