import 'dart:ui';

import 'package:abp_logica/config.dart';
import 'package:abp_logica/headers.widget.dart';
import 'package:abp_logica/pages/Ejercicios/Ejercicios.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String id = "HomePage";

  Size size;
  bool init = false;

  @override
  Widget build(BuildContext context) {
    if (init == false) {
      size = MediaQuery.of(context).size;
      init = true;
    }
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          HeaderCurvo(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: body(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  background() {
    return Image(
        width: size.width,
        fit: BoxFit.cover,
        image: AssetImage("images/fondo.png"));
  }

  body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Image.asset(
          "images/logo.png",
          width: 80,
          // color: primaryColor,
        )),
        SizedBox(
          height: 30,
        ),
        Text("Apps", style: primaryStyle),
        Divider(
          indent: 100,
          endIndent: 100,
          thickness: 2,
          color: primaryColor,
        ),
        SizedBox(
          height: 30,
        ),
        listItems(context),
        SizedBox(
          height: 90,
        ),
      ],
    );
  }

  listItems(BuildContext context) {
    return horizontalScrollBox(size,
        list: [
          // item(context,
          //     titulo: "Conversor",
          //     subTitulo: "Conversor de modenas populares",
          //     image: "images/money.png",
          //     contents: Ejercicio1()), //Ejercicio 1
          // item(context,
          //     titulo: "IMC",
          //     subTitulo: "Calcula de tu IMC",
          //     image: 'images/Fit.png',
          //     contents: Ejercicio2()), //Ejercicio 2
          // item(context,
          //     titulo: "Identidad",
          //     subTitulo: "Guarda tus datos",
          //     image: 'images/verificado.png',
          //     contents: Ejercicio3()), //Ejercicio 3

          // item(context,
          //     titulo: "Cabello",
          //     image: "images/corte-de-pelo.png",
          //     subTitulo: "Calcula el largo de tu cabello",
          //     contents: Ejercicio4()), //Ejercicio 4
          // item(context,
          //     titulo: "Orden",
          //     image: "images/lista.png",
          //     subTitulo: "Ordena una lista de numeros",
          //     contents: Ejercicio5()), //Ejercicio 5
          // item(context,
          //     titulo: "Equivalencia",
          //     image: "images/equivalencia.png",
          //     subTitulo: "observa la equivalencia en otras unidades de medida",
          //     contents: Ejercicio6()), //Ejercicio 6
          // item(context,
          //     titulo: "Año bisiesto",
          //     image: "images/ano-nuevo.png",
          //     subTitulo: "Descubre si un año es bisiesto o no",
          //     contents: Ejercicio7()), //Ejercicio 7
          // item(context,
          //     titulo: "Tu edad",
          //     image: "images/chronometer.png",
          //     subTitulo: "Tu edad desde otra perspectiva!",
          //     contents: Ejercicio8()), //Ejercicio 8
          // item(context,
          //     titulo: "Naranjas",
          //     image: "images/naranja.png",
          //     subTitulo: "Cuantas naranjas necesito?",
          //     contents: Ejercicio9()), //Ejercicio 9
          item(context,
              titulo: "Manzanas",
              image: "images/manzana.png",
              subTitulo: "cuantas manzanas has comido?",
              contents: Ejercicio10()), //Ejercicio 9
        ],
        onTap: () {});
  }

  item(
    BuildContext context, {
    String titulo = "Sin titulo",
    String subTitulo = "Sin sub titulo",
    String image,
    String ruta = 'EjerciciosContainerPage',
    Widget contents,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ruta, arguments: {
          "titulo": titulo,
          "subtitulo": subTitulo,
          "image": image,
          "content": contents
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: Container(
              decoration: ShapeDecoration(
                  gradient:
                      LinearGradient(begin: Alignment.bottomCenter, colors: [
                    Colors.white.withOpacity(0.5),
                    primaryColorOpa,
                  ]),
                  // color:  Li,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              width: 200,
              height: size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  image == null
                      ? Container()
                      : Hero(
                          tag: "$image",
                          child: Image.asset(image, width: size.width / 4)),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    // height: 0.1,
                    indent: 30,
                    endIndent: 30,
                    thickness: 1,
                    color: primaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Container(
                      // width: size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: primaryStyle2,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            subTitulo,
                            style: secondaryStyle,
                            textAlign: TextAlign.left,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
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
