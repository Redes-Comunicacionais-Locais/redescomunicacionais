import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PublicationTermsDialog extends StatefulWidget {
  const PublicationTermsDialog({super.key});

  @override
  State<PublicationTermsDialog> createState() =>
      _PublicationTermsDialogState();
}

class _PublicationTermsDialogState extends State<PublicationTermsDialog> {
  final Map<String, bool> checklist = {
    "titulo_curto_direto": false,
    "texto_simples": false,
    "estrutura_texto": false,

    "fatos_conferidos": false,
    "origem_informacoes_imagens": false,
    "sem_boatos_redes_sociais": false,

    "sem_preconceito_violencia_ofensa": false,
    "privacidade_criancas_vitimas": false,
    "midias_nao_manipuladas": false,
    "sem_ia": false,
    "sem_copia": false,

    "direito_uso_fotos_videos": false,
    "imagem_nao_sensacionalista": false,
    "local_data_fonte_imagens": false,

    "materia_assinada": false,
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
                "1. Clareza da notícia",
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
                "O texto tem princípio (o fato), desenvolvimento (explicação do fato) e fim (desfecho e indicação autorizada de telefones e emails úteis, se for o caso)",
              ),

              const Divider(),

              const Text(
                "2. Qualidade da informação",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildCheckItem(
                "fatos_conferidos",
                "Conferi os fatos e minhas fontes são confiáveis",
              ),

              buildCheckItem(
                "origem_informacoes_imagens",
                "Indiquei claramente a origem das informações e imagens",
              ),

              buildCheckItem(
                "sem_boatos_redes_sociais",
                "Não publiquei nada baseado apenas em boatos ou redes sociais",
              ),

              const Divider(),

              const Text(
                "3. Ética e respeito",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildCheckItem(
                "sem_preconceito_violencia_ofensa",
                "O texto da matéria não contém preconceito, violência nem ofensa",
              ),

              buildCheckItem(
                "privacidade_criancas_vitimas",
                "Protegi a privacidade de crianças e vítimas",
              ),

              buildCheckItem(
                "midias_nao_manipuladas",
                "Não alterei imagens, áudios ou vídeos de forma enganosa",
              ),

              buildCheckItem(
                "sem_ia",
                "Não gerei imagens nem vídeos por inteligência artificial",
              ),

              buildCheckItem(
                "sem_copia",
                "Não copiei esta notícia nem partes dela de outra fonte",
              ),

              const Divider(),

              const Text(
                "4. Imagens e vídeos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildCheckItem(
                "direito_uso_fotos_videos",
                "Fiz a fotos e vídeos ou tenho autorização para usar fotos e vídeos feitos por outras pessoas",
              ),

              buildCheckItem(
                "imagem_nao_sensacionalista",
                "A imagem não é sensacionalista nem constrangedora (estas não devem nunca ser publicadas)",
              ),

              buildCheckItem(
                "local_data_fonte_imagens",
                "Ao final da matéria, identifiquei local, data e fonte das imagens",
              ),

              const Divider(),

              const Text(
                "5. Transparência",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildCheckItem(
                "materia_assinada",
                "Assinei a matéria com meu nome ou perfil",
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