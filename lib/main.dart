import 'package:abp_logica/config.dart';
import 'package:abp_logica/pages/HomePage.dart';
import 'package:abp_logica/preferencias.dart';
import 'package:abp_logica/rutas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.Dart';
import 'package:oktoast/oktoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();

  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      dismissOtherOnShow: true,
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: primaryColor,
            errorColor: Colors.amber.withOpacity(0.7)),
        debugShowCheckedModeBanner: false,
        routes: routes(),
        initialRoute: HomePage.id,
      ),
    );
  }
}
