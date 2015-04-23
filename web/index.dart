import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:taller/components/perfil/perfil.dart';

import 'package:redstone_mapper/mapper_factory.dart';



main() {
  
  bootstrapMapper();
  
  var module = new Module()
    ..bind (Perfil);
  
  applicationFactory()
      .addModule (module)
      .run();
}