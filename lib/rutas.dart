import 'package:abp_logica/pages/HomePage.dart';
import 'package:abp_logica/pages/EjerciciosContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes() {
  return {
    HomePage.id: (_) => HomePage(),
    EjerciciosContainerPage.id: (_) => EjerciciosContainerPage(),
  };
}
