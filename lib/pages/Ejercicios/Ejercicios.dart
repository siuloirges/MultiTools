import 'dart:convert';

import 'package:abp_logica/config.dart';
import 'package:abp_logica/preferencias.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

//============================================================= Ejercicio 1
enum Moneys { EUR, USD, COP, GBP, CHF, JPY, HKD, CAD, CNY }

class Ejercicio1 extends StatefulWidget {
  // const Ejercicio1({Key key}) : super(key: key);
  @override
  _Ejercicio1State createState() => _Ejercicio1State();
}

class _Ejercicio1State extends State<Ejercicio1> {
  final formatter = new NumberFormat("###,###,###", "es-co");
  Size size;

  bool init = false;

  bool resultMaxExtend = false;
  double resultFinal = 0;
  TextEditingController precioAController = TextEditingController();
  Moneys monedaA;
  Moneys monedaB;

  @override
  Widget build(BuildContext context) {
    if (init == false) {
      size = MediaQuery.of(context).size;
      init = true;
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                result(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Selecciona moneda de origen",
                  style: secondaryStyle2,
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: horizontalScrollBox(size, list: [
                    moneyA(Moneys.COP),
                    moneyA(Moneys.USD),
                    moneyA(Moneys.EUR),
                    moneyA(Moneys.GBP),
                    moneyA(Moneys.CHF),
                    moneyA(Moneys.JPY),
                    moneyA(Moneys.HKD),
                    moneyA(Moneys.CAD),
                    moneyA(Moneys.CNY),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Selecciona moneda de destino",
                  style: secondaryStyle2,
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: horizontalScrollBox(size, list: [
                    moneyB(Moneys.COP),
                    moneyB(Moneys.USD),
                    moneyB(Moneys.EUR),
                    moneyB(Moneys.GBP),
                    moneyB(Moneys.CHF),
                    moneyB(Moneys.JPY),
                    moneyB(Moneys.HKD),
                    moneyB(Moneys.CAD),
                    moneyB(Moneys.CNY),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: precioAController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    // icon: Icon(Icons.phone , color:primaryColor),
                    prefixIcon:
                        Icon(Icons.monetization_on, color: segundaryColor),
                    hintText: '\$000.000',
                    labelText: monedaA == null
                        ? 'Precio en Moneda de origen'
                        : 'Precio en ${monedaA.toString().replaceAll("Moneys.", "")}',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onChanged: (value) {},
                ),
                SizedBox(
                  height: 20,
                ),
                primaryButton(context, size,
                    texto: "Convertir",
                    onpress: monedaA == null
                        ? null
                        : monedaB == null
                            ? () {
                                floadMessage(
                                    mensaje:
                                        "No puedes convertir sin moneda de destino");
                              }
                            : () async {
                                if (!resultMaxExtend) {
                                  await calcular();
                                  setState(() {
                                    resultMaxExtend = !resultMaxExtend;
                                  });
                                } else {
                                  setState(() {
                                    resultMaxExtend = !resultMaxExtend;
                                  });
                                  await Future.delayed(
                                      Duration(milliseconds: 500));
                                  await calcular();
                                  await Future.delayed(
                                      Duration(milliseconds: 100));

                                  setState(() {
                                    resultMaxExtend = !resultMaxExtend;
                                  });
                                }
                              }),
                monedaA == null
                    ? Text(
                        "Selecciona las monedas a convertir",
                        style: secondaryStyle,
                      )
                    : Container()
              ]),
        ),
      ),
    );
  }

  moneyA(Moneys id) {
    return id == monedaB
        ? horizontalRoundButton("${id.toString().replaceAll("Moneys.", "")}",
            onTap: () {
            floadMessage(mensaje: "No puedes seleccionar la misma moneda");
          }, disable: true)
        : horizontalRoundButton("${id.toString().replaceAll("Moneys.", "")}",
            active: id == monedaA, onTap: () {
            resultMaxExtend = false;
            monedaA = id;
            setState(() {});
          });
  }

  moneyB(Moneys id) {
    return id == monedaA
        ? horizontalRoundButton("${id.toString().replaceAll("Moneys.", "")}",
            disable: true, onTap: () {
            floadMessage(mensaje: "No puedes seleccionar la misma moneda");
          })
        : horizontalRoundButton("${id.toString().replaceAll("Moneys.", "")}",
            active: id == monedaB, onTap: () {
            resultMaxExtend = false;
            monedaB = id;
            setState(() {});
          });
  }

  calcular() async {
    double valor = await getMethod(
        from: monedaA.toString().replaceAll("Moneys.", ""),
        to: monedaB.toString().replaceAll("Moneys.", ""));
    if (precioAController.text.length != 0) {
      resultFinal = double.parse(precioAController.text.toString()) * valor;
    }
    setState(() {});
  }

  Future<double> getMethod({
    String from,
    String to,
  }) async {
    Map<String, String> head;

    head = {'Accept': 'application/json'};

    try {
      dynamic resp = await http.get(
        "https://api.cambio.today/v1/quotes/$from/$to/json?quantity=1&key=9039|aw7OapbM9E5Xj_faQ2E7W45gAi9n4^*1",
        headers: head,
      );

      Map<dynamic, dynamic> decodeResp = json.decode(resp.body);

      if (resp.statusCode != 200) {
      } else {
        floadMessage(
            mensaje:
                "El precio actual del $to en $from es: ${decodeResp['result']['value']}");
        return decodeResp['result']['value'];
      }
    } catch (e) {
      floadMessage(
          mensaje: "Error al intentar obtener precio de $to actual en dolar");
    }
  }

  result() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: resultMaxExtend ? 1000 : 500,
        ),
        curve: Curves.ease,
        // width: resultMaxExtend ? size.width : 0,
        height: resultMaxExtend ? 75 : 0,
        decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.2),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(resultMaxExtend ? 20 : 20),
                bottomRight: Radius.circular(resultMaxExtend ? 20 : 20))),
        child: Center(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    // "${formatter.format(int.parse(resultFinal.toStringAsFixed(0)))} " +
                    //     monedaB.toString().replaceAll("Moneys.", ""),
                    "${resultFinal.toStringAsFixed(2)} " +
                        monedaB.toString().replaceAll("Moneys.", "") +
                        "s",
                    style: primaryStyle,
                  ),
                  Text(
                    "Resultado de convertir ${monedaA.toString().replaceAll("Moneys.", "")} a ${monedaB.toString().replaceAll("Moneys.", "")}",
                    textAlign: TextAlign.center,
                    style: secondaryStyle2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//============================================================= Ejercicio 2

class Ejercicio2 extends StatefulWidget {
  Ejercicio2({Key key}) : super(key: key);

  @override
  _Ejercicio2State createState() => _Ejercicio2State();
}

class _Ejercicio2State extends State<Ejercicio2> {
  double pesoController = 30.0;
  double alturaController = 1.3;
  double imc = 7.5;
  String msj = "Descubre tu IMC!";
  String msjT = "";
  double valor = 0;
  Size size;

  bool init = false;

  @override
  Widget build(BuildContext context) {
    if (!init) {
      size = MediaQuery.of(context).size;
      init = true;
    }
    return Container(
      height: size.height / 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Peso " + pesoController.toStringAsFixed(1) + " Kg",
                style: secondaryStyle,
              ),
              Slider(
                activeColor: primaryColor,
                label: '$pesoController',
                value: pesoController,
                min: 30.0,
                max: 150.0,
                onChanged: (valor) {
                  print(valor);
                  setState(() {
                    pesoController = valor;
                  });
                  calcularIMC();
                },
              ),
              Text(
                "Altura " + alturaController.toStringAsFixed(2) + " M",
                style: secondaryStyle,
              ),
              Slider(
                // divisions: 28,
                activeColor: primaryColor,
                label: '${alturaController.toStringAsFixed(2)}',
                value: alturaController,
                min: 1.3,
                max: 2.0,
                onChanged: (valor) {
                  print(valor);
                  setState(() {
                    alturaController = valor;
                  });
                  calcularIMC();
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              // primaryButton(context, size, texto: "Calcular", onpress: () {
              //   calcularIMC();
              // }),
              Column(
                children: [
                  Container(
                    width: size.width * 0.72,
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(colors: [
                          Colors.red,
                          Colors.orange,
                          Colors.lightGreen,
                          Colors.green,
                          Colors.lightGreen,
                          Colors.lightGreen,
                          Colors.orange,
                          Colors.orange,
                          Colors.orange,
                          Colors.orange,
                          Colors.red,
                          Colors.red,
                          Colors.red,
                          Colors.red,
                          Colors.red,
                        ])),
                  ),
                  Slider(
                    value: imc,
                    max: 88.8,
                    min: 7.5,
                    onChanged: (v) {},
                    // divisions: 31,
                    activeColor: primaryColor,
                    inactiveColor: Colors.transparent,
                    // mouseCursor: MouseCursor.defer,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                imc?.toStringAsFixed(1) ?? "0",
                style: primaryStyle,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "$msj",
                style: secondaryStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "$msjT",
                    style: primaryStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  calcularIMC() {
    imc = alturaController * alturaController;
    imc = pesoController / imc;
    setState(() {});

    if (imc >= 17.8 && imc <= 18.0) {
      msjT = "Delgado o desnutrido";
      msj =
          "La delgadez puede deberse a diversos factores, tales como genéticos y dietéticos. Independiente de su causa, es importante para tu bienestar mantener un peso saludable.";
    }
    if (imc >= 18.1 && imc <= 24.0) {
      msjT = "Exelente";
      msj =
          "El equilibrio del organismo -su homeostasis- se obtiene con mayor facilidad si el peso de una persona es normal. Una dieta balanceada y ejercicio ayudan a mantenerse en esta categoría.";
    }
    if (imc >= 24.1 && imc <= 29) {
      msjT = "Tiende a obesidad";
      msj =
          "Una mala alimentación y hábitos sedentarios pueden contribuir a acumular grasa en tu cuerpo, lo que puede llevar a problemas médicos en el futuro.";
    }
    if (imc > 29) {
      msjT = "Obeso";
      msj =
          "Cuidado, la obesidad genera complicaciones mayores en el organismo y acorta la vida. Es esencial abordar este estado con una dieta balanceada, ejercicio y, en determinadas ocasiones, con cirugía.";
    }
    if (imc > 40) {
      msjT = "Mal";
      msj = "Preocupate";
    }
  }
}

//============================================================= Ejercicio 3

class Ejercicio3 extends StatefulWidget {
  Ejercicio3({Key key}) : super(key: key);

  @override
  _Ejercicio3State createState() => _Ejercicio3State();
}

class _Ejercicio3State extends State<Ejercicio3> {
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  bool init = false;
  Size size;
  @override
  Widget build(BuildContext context) {
    if (!init) {
      size = MediaQuery.of(context).size;
      init = true;
    }
    return Container(
      height: size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: prefs.nombre ?? "",
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.accessibility_new_rounded,
                      color: segundaryColor),
                  hintText: 'Sergio luis',
                  labelText: "Escribe tu nombre",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  prefs.nombre = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: prefs.edad,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.accessibility_new_rounded,
                      color: segundaryColor),
                  hintText: '19',
                  labelText: "Escribe tu Edad",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  prefs.edad = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: prefs.estatura,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.accessibility_new_rounded,
                      color: segundaryColor),
                  hintText: '1.68',
                  labelText: "Escribe tu estatura",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  prefs.estatura = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              primaryButton(context, size, texto: "Ver mi informacion",
                  onpress: () {
                setState(() {});
              }),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primaryColorOpa,
                  ),
                  height: 80,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Table(
                      children: [
                        TableRow(children: [
                          Text(
                            "Nombre",
                            style: secondaryStyle,
                          ),
                          Text("Edad", style: secondaryStyle),
                          Text("Estatura", style: secondaryStyle)
                        ]),
                        TableRow(children: [
                          Text(
                            "${prefs.nombre ?? ""}",
                            style: secondaryStyle,
                            maxLines: 2,
                          ),
                          Text("${prefs.edad}", style: secondaryStyle),
                          Text("${prefs.estatura}", style: secondaryStyle)
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              prefs.nombre != null
                  ? Text("ahora tus datos se han guardado para siempre 😊",
                      style: secondaryStyle)
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

//============================================================= Ejercicio 4

class Ejercicio4 extends StatefulWidget {
  Ejercicio4({Key key}) : super(key: key);

  @override
  _Ejercicio4State createState() => _Ejercicio4State();
}

class _Ejercicio4State extends State<Ejercicio4> {
  double aniosController = 0;

  double valor = 0;
  Size size;

  bool init = false;

  @override
  Widget build(BuildContext context) {
    if (!init) {
      size = MediaQuery.of(context).size;
      init = true;
    }
    return Container(
      height: size.height / 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Años vividos " + aniosController.toStringAsFixed(0),
                style: secondaryStyle,
              ),
              Slider(
                activeColor: primaryColor,
                label: '${aniosController.toStringAsFixed(0)}',
                value: aniosController,
                min: 0.0,
                divisions: 115,
                max: 115,
                onChanged: (valor) {
                  print(valor);
                  setState(() {
                    aniosController = valor;
                  });
                  calcularLargo();
                },
              ),
              Text(
                valor.toStringAsFixed(1).toString() + " Metros" ?? "0",
                style: primaryStyle,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "${valor.toStringAsFixed(1)}m medira tu pelo si nunca le hubieses dado chamba al peluquero ",
                style: secondaryStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  calcularLargo() {
    valor = (((aniosController * 360) / 30) * 4) * 0.01;
    setState(() {});
  }
}

//============================================================= Ejercicio 5

class Ejercicio5 extends StatefulWidget {
  Ejercicio5({Key key}) : super(key: key);

  @override
  _Ejercicio5State createState() => _Ejercicio5State();
}

class _Ejercicio5State extends State<Ejercicio5> {
  int tempValue = 0;
  Size size;
  bool init = false;
  List<int> listNDesoirdenada = [];
  List<Widget> listNWidgetDesordenada = [];

  @override
  Widget build(BuildContext context) {
    if (!init) {
      size = MediaQuery.of(context).size;
      init = true;
    }
    listNWidgetDesordenada = [];

    listNDesoirdenada?.forEach((element) {
      listNWidgetDesordenada.add(item(element));
    });

    return Container(
      height: size.height / 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width,
                height: size.height / 2,
                child: GridView.count(
                    key: Key("1"),
                    crossAxisCount: 5,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    children: listNWidgetDesordenada..add(itemAdd())),
              ),
              primaryButton(context, size, texto: "Ordenar Lista", onpress: () {
                ordenar(listNDesoirdenada);
              }),
            ],
          ),
        ),
      ),
    );
  }

  item(int index) {
    return FadeInLeft(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: primaryColorOpa,
          ),
          child: Center(child: Text("$index")),
        ),
      ),
    );
  }

  itemAdd() {
    return FadeInLeft(
        from: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                alerta(context,
                    contenido: Container(
                      width: 180,
                      child: TextFormField(
                        autovalidate: true,
                        validator: (v) {
                          if (v.length > 3) {
                            return "solo 3 numeros porfavor";
                          }
                        },
                        keyboardType: TextInputType.number,
                        onChanged: (v) {
                          tempValue = int.parse(v);
                          print(tempValue);
                        },
                        decoration: InputDecoration(
                          hintText: "numero",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    acciones: RaisedButton(
                        child: Text(
                          "Añadir",
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: primaryColor,
                        onPressed: () async {
                          print(tempValue);
                          if (tempValue.toString().length > 3) {
                            return null;
                          }
                          // } else {
                          Navigator.pop(context);
                          await Future.delayed(Duration(milliseconds: 500));
                          listNDesoirdenada.add(tempValue);
                          tempValue = 0;
                          setState(() {});
                          // }
                        }));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColorOpa,
                ),
                width: 40,
                height: 40,
                child: Icon(Icons.add),
              )),
        ));
  }

  ordenar(List<int> numeros) async {
    List<int> n = numeros;
    int i, j, aux, min;

    for (i = 0; i < n.length; i++) {
      min = i;
      for (j = i + 1; j < n.length; j++) {
        if (n[j] < n[min]) {
          min = j;
        }
      }
      aux = n[i];
      n[i] = n[min];
      n[min] = aux;
    }
    n = [];
    setState(() {});
  }
}

//============================================================= Ejercicio 6

class Ejercicio6 extends StatefulWidget {
  Ejercicio6({Key key}) : super(key: key);

  @override
  _Ejercicio6State createState() => _Ejercicio6State();
}

class _Ejercicio6State extends State<Ejercicio6> {
  Size size;
  bool init = false;
  int cantidad = 0;

  @override
  Widget build(BuildContext context) {
    if (!init) {
      size = MediaQuery.of(context).size;
      init = true;
    }
    return Container(
      height: size.height / 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //0011

              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.calculate_rounded, color: segundaryColor),
                  hintText: 'gramos',
                  labelText: "Cantidad en gramos",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  cantidad = int.parse(value);
                  setState(() {});
                },
              ),
              SizedBox(
                height: 20,
              ),

              Text(
                "En Miligramos es: ${(cantidad * 1000).toStringAsFixed(2)}",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "En hectogramos es: ${(cantidad * 0.01).toStringAsFixed(2)}",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "En kilogramos es: ${(cantidad * 0.001).toStringAsFixed(2)}",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "En decigramos es: ${(cantidad * 10).toStringAsFixed(2)}",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "En centigramos es: ${(cantidad * 100).toStringAsFixed(2)}",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "En libras metricas es: ${(cantidad * 0.00220462).toStringAsFixed(2)}",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "En decagramos es: ${(cantidad * 0.1).toStringAsFixed(2)}",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "En toneladas es: ${(cantidad * 0.001).toStringAsFixed(2)}",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "En onzas es: ${(cantidad * 35.274).toStringAsFixed(2)}",
                style: secondaryStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//============================================================= Ejercicio 7

class Ejercicio7 extends StatefulWidget {
  Ejercicio7({Key key}) : super(key: key);

  @override
  _Ejercicio7State createState() => _Ejercicio7State();
}

class _Ejercicio7State extends State<Ejercicio7> {
  Size size;
  bool init = false;
  int anio;
  @override
  Widget build(BuildContext context) {
    if (!init) {
      size = MediaQuery.of(context).size;
      init = true;
    }

    return Container(
      height: size.height / 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //0011

              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.calculate_rounded, color: segundaryColor),
                  hintText: 'año',
                  labelText: "Digite el año",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  print(anio);
                  anio = int.parse(value.length == 0 ? "0" : value);
                  if (anio == 0) {
                    print("null");
                    anio = null;
                  }

                  setState(() {});
                },
              ),
              SizedBox(
                height: 20,
              ),

              anio != null
                  ? Text(
                      (anio % 4 == 0 && anio % 100 != 0) || anio % 400 == 0
                          ? "El Año si es bisiesto"
                          : "El año no es bisiesto",
                      style: primaryStyle,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

//============================================================= Ejercicio 8

class Ejercicio8 extends StatefulWidget {
  Ejercicio8({Key key}) : super(key: key);

  @override
  _Ejercicio8State createState() => _Ejercicio8State();
}

class _Ejercicio8State extends State<Ejercicio8> {
  Size size;
  bool init = false;
  int cantidad = 0;

  @override
  Widget build(BuildContext context) {
    if (!init) {
      size = MediaQuery.of(context).size;
      init = true;
    }
    return Container(
      height: size.height / 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //0011

              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.calculate_rounded, color: segundaryColor),
                  hintText: 'edad',
                  labelText: "Escriba su edad",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  cantidad = int.parse(value);
                  setState(() {});
                },
              ),
              SizedBox(
                height: 20,
              ),

              Text(
                "has vivido: $cantidad años",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 0.01).toStringAsFixed(2)} siglos",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 0.1).toStringAsFixed(2)} decadas",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 2).toStringAsFixed(2)} semestres",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 4).toStringAsFixed(2)} trimestres",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 6).toStringAsFixed(2)} bimestres",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 12).toStringAsFixed(2)} meses",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 24).toStringAsFixed(2)} Quinsenas",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 52.143).toStringAsFixed(2)} semana",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 365).toStringAsFixed(2)} Dias",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${((cantidad * 365) / 4).toStringAsFixed(2)} Jornadas dia",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${((cantidad * 365) / 4).toStringAsFixed(2)} Jornadas noche",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${((cantidad * 365) / 4).toStringAsFixed(2)} Jornadas mañana",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${((cantidad * 365) / 4).toStringAsFixed(2)} Jornadas tarde",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 8760).toStringAsFixed(2)} Horas",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 525600).toStringAsFixed(2)} Minutos",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 3.154).toStringAsFixed(2)} Segundos",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 52.143).toStringAsFixed(2)} Domingos",
                style: secondaryStyle,
              ),
              Divider(),
              Text(
                "has vivido: ${(cantidad * 3.154).toStringAsFixed(2)} Mili-segundos",
                style: secondaryStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//============================================================= Ejercicio 9

class Ejercicio9 extends StatefulWidget {
  Ejercicio9({Key key}) : super(key: key);

  @override
  _Ejercicio9State createState() => _Ejercicio9State();
}

class _Ejercicio9State extends State<Ejercicio9> {
  Size size;
  bool init = false;
  int kilovoltios = 0;
  double naranjas = 0;
  double toneladas = 0;

  @override
  Widget build(BuildContext context) {
    if (!init) {
      size = MediaQuery.of(context).size;
      init = true;
    }
    return Container(
      height: size.height / 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //0011

              SizedBox(
                height: 20,
              ),
              Text(
                "¿Cuantos Kilovoltios requiere su sistema de iluminación?",
                style: primaryStyle,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.calculate_rounded, color: segundaryColor),
                  hintText: 'Kilovoltios',
                  labelText: "Escriba los Kilovoltios",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  kilovoltios = int.parse(value);
                  naranjas = kilovoltios / 0.05;
                  toneladas = ((naranjas * 6) * 0.001) * 0.001;
                  setState(() {});
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "su sistema de iluminacion requiere de ${naranjas.toStringAsFixed(0)} unidades naranjas o $toneladas toneladas de naranja para funcionar",
                style: secondaryStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//============================================================= Ejercicio 10

class Ejercicio10 extends StatefulWidget {
  Ejercicio10({Key key}) : super(key: key);

  @override
  _Ejercicio10State createState() => _Ejercicio10State();
}

class _Ejercicio10State extends State<Ejercicio10> {
  Size size;
  bool init = false;
  int edad = 0;
  double kilogramos = 0;
  double gramos = 0;
  double manzanas = 0;

  @override
  Widget build(BuildContext context) {
    if (!init) {
      size = MediaQuery.of(context).size;
      init = true;
    }
    return Container(
      height: size.height / 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //0011

              SizedBox(
                height: 20,
              ),
              Text(
                "¿Cuantas piezas de frutas has comido aproximadamente?",
                style: primaryStyle,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.accessibility_new_rounded,
                      color: segundaryColor),
                  hintText: 'edad',
                  labelText: "Dijite su edad",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  edad = int.parse(value);
                  kilogramos = edad.toDouble() * 8;
                  gramos = kilogramos * 1000;
                  manzanas = gramos / 4;
                  setState(() {});
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Usted consumió aproximadamente $gramos gr de frutas, lo que equivale $manzanas manzanas.",
                style: secondaryStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
