import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET de la última página

  get nombre {
    return _prefs.getString('nombre') ?? null;
  }

  set nombre(String value) {
    _prefs.setString('nombre', value);
  }

  get edad {
    return _prefs.getString('edad') ?? '';
  }

  set edad(String value) {
    _prefs.setString('edad', value);
  }

  get estatura {
    return _prefs.getString('estatura') ?? '';
  }

  set estatura(String value) {
    _prefs.setString('estatura', value);
  }



}
