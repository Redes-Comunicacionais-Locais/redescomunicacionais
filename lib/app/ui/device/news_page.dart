import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Noticia completa"),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.black],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                /*child: Image.memory(
                        movie["image"],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),*/
                child: Image.network(
                  "https://cmssalto.rj.gov.br/wp-content/uploads/2020/10/FOTO-SAO-SEBASTIAO-DO-ALTO.jpg", // Substitua com a URL da imagem desejada
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Expanded(
                child: Text(
                  "Eleições 2024: Claudiane Pietrani, do SOLIDARIEDADE, é eleita prefeita de São Sebastião do Alto no 1º turno",
                  style:  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
            ],
          ),
          const Text("Fontinele sinistro",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 12)),
          const SizedBox(
            height: 20,
          ),
          const Text("Claudiane Pietrani, do SOLIDARIEDADE, foi eleita prefeita de São Sebastião do Alto (RJ) neste domingo (6), com 3.474 votos, correspondendo a 51,22% dos votos válidos. A eleição teve 7.041 votos totais, incluindo 68 votos brancos (0,97%) e 191 nulos (2,71%). Aledio Rezende, do PL, obteve 3.308 votos, 48,78% dos votos válidos. Esses dados foram divulgados pelo Tribunal Superior Eleitoral (TSE).",
              style:  TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ],
      ),
    );
  }
}
