class NewsModel {
  String id;
  String titulo;
  String cidade;

  NewsModel({this.id = '', required this.titulo, required this.cidade});

  // Converter para Map (para enviar ao Firebase)
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'cidade': cidade,
    };
  }

  // Criar um objeto NewsModel a partir de um documento do Firestore
  factory NewsModel.fromMap(String id, Map<String, dynamic> data) {
    return NewsModel(
      id: id,
      titulo: data['titulo'] ?? '',
      cidade: data['cidade'] ?? '',
    );
  }
}
