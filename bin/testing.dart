library testing;

import 'dart:async';
import 'package:taller/modelos/usuario.dart';
import 'package:redstone/mocks.dart';
import 'package:di/di.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'servicios_usuario.dart';
import 'dart:math' as math;








import 'package:mock/mock.dart';
import 'package:unittest/unittest.dart';

main ()
{
  test('testbasico', () async {
    var x = 1 + 2;
    expect(x, 3);
  });
  
  
  
  
  
  
  
  algunIterable () sync * //IEnumerable
  {
    yield 1;
    yield 2;
    yield 3;
  }
  test ("test con iterables", ()
  {
    var lista = [1, 2, 3];
    var iterable = algunIterable();
    
    expect (lista, iterable);
  });
  
  
  
  
  
  
  
  
  
  
  
  group ("Matematica:", () {
    suma (a, b) => a + b;
    maximo (a, b) => a > b ? a : b;
    List<int> lista;
    
    setUp((){
      lista = [1, 2, 3];
    });
    
    tearDown((){
      lista = null;
    });
    
    
    test('total', () async{
      //Validar funcion
      expect(suma(3, 5), 8);
      //Agregar 4
      lista.add(4);
      //Calcular total
      var total = lista.reduce(suma);
      //Validar suma total
      expect(total, 10);
    });
    
    
    
    
    
    
    
    
    
    
    test('maximo', () async {
      //Validar funcion
      expect (maximo(3, 5), 5);
      //Calcular total
      var maxLista = lista.reduce(maximo);
      //Validar suma total
      expect(maxLista, 3);
    });
  });
    
    
    
    
    
    
    
    
    
    
    
    
  group ('Mocks:', () {
    
    test('sin mock', () async {
      //Crear cafeteria
      var cafeteria = new Cafeteria()
        ..usuarios = [
          new Usuario()..nombre = "Cristian",
          new Usuario()..nombre = "Esteban"
        ];
      //Crear administracion
      var administracion = new Administracion (cafeteria);
      //Calcular ganancias
      var costos = 2;
      var ganacias = administracion.calcularGanancias (costos);
      //Validar ==> error porque las ventas son aleatorias
      //expect (ganacias, 4);
      //Otra forma de validar
      expect(ganacias <= 10 - costos, true);
    });
    
    
    
    
    
    
    
    
    
    
    
    
    
    test('con mock', () async {
      //Crear cafeteria
      var cafeteria = new CafeteriaMock();
      //Asignar comportamiento
      cafeteria
        .when(callsTo("ventas"))
        .thenReturn(6);
      
      cafeteria
        .when(callsTo("ventas"))
        .alwaysReturn(7);
      
      //Crear administracion
      var administracion = new Administracion(cafeteria);
      //Calcular ganancias
      var costos = 2;
      var ganacias = administracion.calcularGanancias(costos);
      //Validar => resultado exacto
      expect (ganacias, 4);
      
      ganacias = administracion.calcularGanancias(costos);
      //Validar => resultado exacto
      expect (ganacias, 5);
      
      ganacias = administracion.calcularGanancias(costos);
    });
    
    
    
    
    
    
    
    
    
    
    
    
    test('logs', () async {
      //Crear cafeteria
      var cafeteria = new CafeteriaMock();
      
      //cafeteria.when(callsTo("ventas")).alwaysReturn(5);
      
      //Crear administracion
      var administracion = new Administracion(cafeteria);
      
      //Agregar administrado
      administracion
        ..agregarAdministrador("Cristian")
        ..agregarAdministrador("Esteban");
      
      //administracion.calcularGanancias(2);
      
      //Validar que no se llame cafeteria.ventas()
      cafeteria
        .getLogs(callsTo("ventas"))
        .verify(neverHappened);
    });
    
    
    
    
    
    
    
    
    
    
    
    
    test('spy', () async {
      //Crear cafeteria
      var cafeteria = new CafeteriaMock();
      
      //Crear administracion
      var real = new Administracion(cafeteria);
      var administracion = new AdministracionMock.spy(real);
      
      //Agregar administradores
      administracion
        ..agregarAdministrador("Cristian")
        ..agregarAdministrador("Esteban");
      //Calcular numero de administradores
      var numeroAdmins = administracion.numeroAdministradores();
      expect (numeroAdmins, 3);
      
      //Eliminar admin
      administracion.eliminarAdministrador("Juan Perez");
      numeroAdmins = administracion.numeroAdministradores();
      expect (numeroAdmins, 2);
      
      //Validar numero de llamadas
      administracion
        .getLogs(callsTo('agregarAdministrador'))
        .verify(happenedExactly(2));
      
      administracion
        .getLogs(callsTo('numeroAdministradores'))
        .verify(sometimeReturned(3))
        .verify(sometimeReturned(2));
      
      //Validar que no se llame cafeteria.ventas()
      cafeteria
        .getLogs(callsTo("ventas"))
        .verify(neverHappened);
    });
    
  });
  
}



class Cafeteria 
{
  List<Usuario> usuarios  = [];
  ventas () => usuarios
      .map((usuario) => new math.Random().nextDouble() * 5)
      .reduce((a,b) => a + b);
}

class Administracion
{
  List<String> _nombreAdministradores = ["Juan Perez"];
  Cafeteria cafeteria;
  
  Administracion (this.cafeteria);
  
  num calcularGanancias (num costos) => cafeteria.ventas() - costos;
  
  int numeroAdministradores () => _nombreAdministradores.length;
  
  void agregarAdministrador (String admin)
  {
    _nombreAdministradores.add(admin);
  }
  
  void eliminarAdministrador (String admin)
  {
    _nombreAdministradores.remove(admin);
  }
  
  
}










//noSuchMethod
class CafeteriaMock extends Mock implements Cafeteria {}











class AdministracionMock extends Mock implements Administracion
{
  AdministracionMock ();
  AdministracionMock.spy (Administracion real) : super.spy (real);
}






class ServiciosUsuarioMock extends Mock implements ServiciosUsuario {}