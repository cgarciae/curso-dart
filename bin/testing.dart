library testing;

import 'dart:async';
import 'package:taller/modelos/usuario.dart';
import 'package:unittest/unittest.dart';
import 'package:http/http.dart' as http;
import 'package:redstone/server.dart' as app;
import 'dart:io' as io;
import 'package:redstone/mocks.dart';
import 'package:di/di.dart';
import 'package:mock/mock.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'package:redstone_mapper/plugin.dart';
import 'servicios_usuario.dart';




main ()
{
  group ("Tests", (){
    setUp((){
      //Se ejecuta antes de cada test
    });
    tearDown((){
      //Se ejecuta despues de cada test
    });
    
    test('testbasico', () async{
      var x = 1 + 1;
      expect(x, 2);
    });
    
    
    
    
    
    
    
    
    
    
    
    iterable () sync * //IEnumerable
    {
      yield 1;
      yield 2;
      yield 3;
    }
    
    
    test('test con iterables', () async{
      var x = [1,2,3];
      expect(x, iterable());
    });
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Mocks
    
    test('mocks', () async{
      //Crear mock
      var userServices = new ServiciosUsuarioMock();
      
      //Crear data
      var user = new Usuario()
        ..nombre = "Cristian"
        ..apellido = "Garcia";
      
      //Asignar acciones
      userServices.when(callsTo('Get')).thenReturn(new Future.value(user));
      
      //Ejecutar acciones
      var usuarioDevuelto = await userServices.Get("");
      
      //Validar
      expect(usuarioDevuelto, user);
    });
    
  });
}


class ServiciosUsuarioMock extends Mock implements ServiciosUsuario {}

