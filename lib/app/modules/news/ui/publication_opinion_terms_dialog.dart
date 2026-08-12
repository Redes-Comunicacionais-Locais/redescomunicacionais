import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PublicationOpinionTermsDialog extends StatefulWidget {
  const PublicationOpinionTermsDialog({super.key});

  @override
  State<PublicationOpinionTermsDialog> createState() =>
      _PublicationOpinionTermsDialogState();
}

class _PublicationOpinionTermsDialogState
    extends State<PublicationOpinionTermsDialog> {
  final Map<String, bool> checklist = {
    "titulo_curto_direto": false,
    "texto_simples": false,
    "estrutura_texto": false,
    "pessoas_respeitosamente": false,
    "fatos_dados_conferidos": false,
    "opiniao_com_fundamento": false,
    "assumo_opiniao_posicionamento": false,
    "revisao_gramatical": false,
  };

  bool get allAccepted =>
      checklist.values.every((item) => item == true);

  Widget buildCheckItem(
      String key,
      String text,
      ) {
    return CheckboxListTile(
      value: checklist[key],
      onChanged: (value) {
        setState(() {
          checklist[key] = value ?? false;
        });
      },
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Guia Rápido de Publicação – RCL",
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "1. Clareza do artigo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildCheckItem(
                "titulo_curto_direto",
                "O título está curto e direto",
              ),

              buildCheckItem(
                "texto_simples",
                "O texto está simples, sem palavras difíceis",
              ),

              buildCheckItem(
                "estrutura_texto",
                "O texto tem princípio, meio e fim, ou seja, desenvolve um argumento completo",
              ),

              buildCheckItem(
                "pessoas_respeitosamente",
                "Se me refiro a pessoas, faço isso de forma respeitosa",
              ),

              buildCheckItem(
                "fatos_dados_conferidos",
                "Se uso fatos e dados para embasar meu artigo, declaro que conferi todos eles e que não contém erros nem são fake news",
              ),

              buildCheckItem(
                "opiniao_com_fundamento",
                "Minha opinião no texto tem fundamento",
              ),

              buildCheckItem(
                "assumo_opiniao_posicionamento",
                "Assumo a opinião e o posicionamento que estou publicando",
              ),

              buildCheckItem(
                "revisao_gramatical",
                "Fiz a revisão gramatical do texto",
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "Cancelar",
          ),
        ),
        ElevatedButton(
          onPressed: allAccepted
              ? () {
            Get.back(
              result: {
                "acceptedAll": true,
                "checklist": checklist,
              },
            );
          }
              : null,
          child: const Text(
            "Confirmar publicação",
          ),
        ),
      ],
    );
  }
}