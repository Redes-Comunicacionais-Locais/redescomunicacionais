class NewsModel {
  String id;
  String titulo;
  String subtitulo;
  String cidade;
  String categoria;
  String corpo;
  String imgurl;
  String autor;
  String email;
  String dataCriacao;

  NewsModel(
      {this.id = '',
      required this.titulo,
      required this.subtitulo,
      required this.cidade,
      required this.categoria,
      required this.corpo,
      required this.imgurl,
      required this.autor,
      required this.email,
      required this.dataCriacao});

  // Converter para Map (para enviar ao Firebase)
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'subtitulo': subtitulo,
      'cidade': cidade,
      'categoria': categoria,
      'corpo': corpo,
      'imgurl': imgurl,
      'autor': autor,
      'email': email,
      'dataCriacao': dataCriacao
    };
  }

  // Criar um objeto NewsModel a partir de um documento do Firestore
  factory NewsModel.fromMap(String id, Map<String, dynamic> data) {
    return NewsModel(
      id: id,
      titulo: data['titulo'] ?? '',
      subtitulo: data['subtitulo'] ?? '',
      cidade: data['cidade'] ?? '',
      categoria: data['categoria'] ?? '',
      corpo: data['corpo'] ?? '',
      imgurl: data['imgurl'] ?? '',
      autor: data['autor'] ?? '',
      email: data['email'] ?? '',
      dataCriacao: data['dataCriacao'] ?? '',
    );
  }
}
