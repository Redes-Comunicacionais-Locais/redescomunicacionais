import 'package:get/get.dart';
import 'package:redescomunicacionais/app/data/model/news_model.dart';
import 'package:redescomunicacionais/app/data/repository/news_repository.dart';

class NewsController extends GetxController {
  final NewsRepository _repository = NewsRepository();
  var newss = <NewsModel>[].obs;
  var isLoading = false.obs;

  // Adicionar notícias
  Future<void> adicionarNews(String titulo, String cidade) async {
    try {
      isLoading(true);
      NewsModel news = NewsModel(titulo: titulo, cidade: cidade);
      await _repository.adicionarNews(news);
      newss.add(news);
      Get.snackbar('Sucesso', 'Notícias cadastrado com sucesso!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível cadastrar a notícias.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // Buscar notícias
  Future<void> buscarNews() async {
    try {
      isLoading(true);
      newss.value = await _repository.buscarNews();
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar as notícias.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
