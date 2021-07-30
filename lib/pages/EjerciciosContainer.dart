import 'dart:ui';

import 'package:abp_logica/config.dart';
import 'package:abp_logica/headers.widget.dart';
import 'package:flutter/material.dart';

class EjerciciosContainerPage extends StatelessWidget {
  static String id = "EjerciciosContainerPage";

  Size size;
  bool init = false;

  dynamic parameters;
  @override
  Widget build(BuildContext context) {
    if (init == false) {
      parameters = ModalRoute.of(context).settings.arguments;
      size = MediaQuery.of(context).size;
      init = true;
    }
    return Scaffold(
      body: Stack(
        children: [
          HeaderDiagonal(),
          SafeArea(
            child: title(context),
          ),
          SafeArea(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: item(
              context,
              titulo: parameters['titulo'],
              subTitulo: parameters['subtitulo'],
              imagen: parameters['image'],
              contents: parameters['content'],
            ),
          ))
        ],
      ),
    );
  }

  title(context) {
    return Column(
      children: [
        SizedBox(
          height: size.height / 85,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                }),
            SizedBox(
              width: 5,
            ),
            Text("${parameters['titulo']}", style: primaryStyle3),
            SizedBox(
              width: 5,
            ),
            IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: Colors.transparent),
                onPressed: () {}),
          ],
        ),
        Divider(
          // height: 0.1,
          indent: 100,
          endIndent: 100,
          thickness: 1,
          color: Colors.white,
        ),
      ],
    );
  }

  item(context,
      {String titulo = "Sin titulo",
      String subTitulo = "Sin sub titulo",
      String imagen = "images/Fit.png",
      Widget contents}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
        child: Container(
          decoration: ShapeDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          // height: 60,
          child: SingleChildScrollView(
            child: Container(
              width: size.width / 1.1,
              // color: Colors.black26,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                            tag: parameters['image'],
                            child: Image.asset(imagen, width: size.width / 9)),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          // width: size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titulo,
                                style: primaryStyle2,
                                textAlign: TextAlign.left,
                              ),
                              Container(
                                width: size.width / 1.5,
                                child: Text(
                                  subTitulo,
                                  style: secondaryStyle,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: size.width / 1.1,
                    height: 600,
                    color: Colors.white.withOpacity(0.5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [contents ?? Text("sin contents")],
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
