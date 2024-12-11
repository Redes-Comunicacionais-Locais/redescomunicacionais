import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    return VerticalCardPager(
      titles: const ["Eleições 2024: Claudiane Pietrani, do SOLIDARIEDADE, é eleita prefeita de São Sebastião do Alto no 1º turno",
       "Eleições 2024 em São Sebastião do Alto (RJ): veja os candidatos a prefeito e a vereador",
        "Atleta de São Sebastião do alto consquista bicampeonato carioca de ciclismo"],
      images: [
        Container(
          color: Colors.black,
        ),
        Container(color: Colors.black),
        Container(color: Colors.black),
      ],
      textStyle: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold,),
          onSelectedItem:  (index){Get.toNamed(Routes.NEWSPAGE);}
           // optional
    );
  }
}
