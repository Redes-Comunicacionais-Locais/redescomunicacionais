import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

class News extends StatelessWidget {
  News({super.key});
  
  final List<String> titles = [
    "Eleições 2024: Claudiane Pietrani, do SOLIDARIEDADE, é eleita prefeita de São Sebastião do Alto no 1º turno",
  ];

  final List<Widget> images = [
  ];

  @override
  Widget build(BuildContext context) {
    return VerticalCardPager(
      titles: [""],
      images: [
        Container(
          color: Colors.black,
          child: Column(
            children: [
              Expanded(
                flex: 3, // A imagem ocupará 3 partes
                child: Image.network(
                  "https://cmssalto.rj.gov.br/wp-content/uploads/2020/10/FOTO-SAO-SEBASTIAO-DO-ALTO.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Expanded(
                flex: 2, // O fundo preto ocupará 2 partes
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      titles[0],  // Aqui estamos passando o título da lista `titles`
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,  // Centraliza o texto
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
     
      onSelectedItem: (index) {
        Get.toNamed(Routes.NEWSPAGE);
      },
    );
  }
}
