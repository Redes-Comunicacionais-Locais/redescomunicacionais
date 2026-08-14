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
    "primeiro_paragrafo_responde": false,
    "texto_simples": false,

    "fatos_conferidos_duas_fontes": false,
    "origem_informacoes_indicada": false,
    "sem_boatos_redes_sociais": false,

    "sem_preconceito_violencia_ofensa": false,
    "privacidade_protegida": false,
    "midias_nao_manipuladas": false,

    "titulo_informativo": false,
    "lead_completo": false,
    "corpo_com_contexto": false,
    "encerramento_com_contatos": false,

    "direito_uso_imagem_video": false,
    "local_data_autor_identificados": false,
    "imagem_nao_sensacionalista": false,

    "materia_assinada": false,
    "erros_corrigidos_atualizacoes": false,

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

      controlAffinity:
      ListTileControlAffinity.leading,

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

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [


              const Text(
                "1. Clareza da notícia",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildCheckItem(
                "titulo_curto_direto",
                "O título está curto e direto?",
              ),

              buildCheckItem(
                "primeiro_paragrafo_responde",
                "O primeiro parágrafo responde o quê, quem, onde e quando?",
              ),

              buildCheckItem(
                "texto_simples",
                "O texto está simples, sem palavras difíceis?",
              ),



              const Divider(),


              const Text(
                "2. Qualidade da informação",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildCheckItem(
                "fatos_conferidos_duas_fontes",
                "Conferi os fatos em pelo menos 2 fontes confiáveis?",
              ),

              buildCheckItem(
                "origem_informacoes_indicada",
                "Indiquei claramente a origem das informações?",
              ),

              buildCheckItem(
                "sem_boatos_redes_sociais",
                "Não publiquei nada baseado apenas em boatos ou redes sociais?",
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
                "O texto não contém preconceito, violência ou ofensa?",
              ),

              buildCheckItem(
                "privacidade_protegida",
                "Protegi a privacidade de crianças e vítimas?",
              ),

              buildCheckItem(
                "midias_nao_manipuladas",
                "Não alterei imagens, áudios ou vídeos de forma enganosa?",
              ),



              const Divider(),


              const Text(
                "4. Estrutura mínima",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildCheckItem(
                "titulo_informativo",
                "Título → informativo",
              ),

              buildCheckItem(
                "lead_completo",
                "Lead → o essencial (o quê, quem, onde, quando)",
              ),

              buildCheckItem(
                "corpo_com_contexto",
                "Corpo → contexto, explicações, falas de fontes",
              ),

              buildCheckItem(
                "encerramento_com_contatos",
                "Encerramento → próximos passos ou contatos úteis",
              ),



              const Divider(),


              const Text(
                "5. Imagens e vídeos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildCheckItem(
                "direito_uso_imagem_video",
                "Tenho direito de usar essa foto/vídeo?",
              ),

              buildCheckItem(
                "local_data_autor_identificados",
                "Identifiquei local, data e autor quando possível?",
              ),

              buildCheckItem(
                "imagem_nao_sensacionalista",
                "A imagem não é sensacionalista nem constrangedora?",
              ),



              const Divider(),


              const Text(
                "6. Transparência",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              buildCheckItem(
                "materia_assinada",
                "Assinei a matéria com meu nome ou perfil?",
              ),

              buildCheckItem(
                "erros_corrigidos_atualizacoes",
                "Corrigi erros ou atualizei a notícia, se necessário?",
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