import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:redescomunicacionais/app/modules/news/controller/news_controller.dart';
import 'package:redescomunicacionais/app/modules/news/data/repository/news_repository.dart';
import 'package:redescomunicacionais/app/modules/user/data/repository/user_repository.dart';
import 'package:redescomunicacionais/app/modules/user/data/model/user_model.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/modules/connections/controller/connections_controller.dart';

class HomeController extends GetxController {
  NewsController? _newsController;
  NewsController get newsController =>
      _newsController ??= Get.find<NewsController>();

  late ConnectionsController connectionsController;

  final UserRepository _userRepository = UserRepository();
  final NewsRepository _newsRepository = NewsRepository();

  UserModel user = UserModel.empty();

  bool get isAnonymousUser => user.id.isEmpty && user.email.isEmpty;

  final RxString appVersion = 'Carregando...'.obs;
  final RxString connectionTypeLabel = 'Sem conexão'.obs;

  RxBool isLoadingLocation = false.obs;
  RxBool isRevisionMode = false.obs;
  RxBool isDraftMode = false.obs;
  RxBool isMyDraftsMode = false.obs;
  RxBool isRejectedMode = false.obs;
  RxBool isDeletedMode = false.obs;
  final RxBool isOnline = false.obs;

  /// chave usada para forçar recriação de widgets
  final RxInt _recreateKey = 0.obs;
  int get recreateKey => _recreateKey.value;
  void forceRecreate() => _recreateKey.value++;

  @override
  Future<void> onInit() async {
    connectionsController = Get.find<ConnectionsController>();
    user = await _userRepository.getCurrentUser();
    _loadPackageInfo();
    super.onInit();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
    } catch (_) {
      appVersion.value = '--';
    }
  }

  void filterNewsByName(String name) {
    newsController.publishedNewsList.value = newsController.publishedNewsList
        .where((news) => news.title.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }

  Future<void> refreshDashboardData() async {
    try {
      await _newsRepository.syncNewsHiveAndFirebase(user);
      await newsController.getPublicNewsFromHive(null);
      await newsController.getOuthersNewsFromHive();
      forceRecreate();
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível atualizar os dados. Verifique sua conexão.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void goUserGuide() {
    Get.toNamed(Routes.WEB_VIEW, arguments: {
      'url': 'https://redescomunicacionaislocais.uff.br/guia-do-usuario/',
      'title': 'Guia do Usuário'
    });
  }

  void goFAQ() {
    Get.toNamed(Routes.WEB_VIEW, arguments: {
      'url':
          'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki/Perguntas-Frequentes',
      'title': 'Perguntas Frequentes'
    });
  }

  void goAboutUs() {
    Get.toNamed(Routes.WEB_VIEW, arguments: {
      'url': 'https://redescomunicacionaislocais.uff.br/',
      'title': 'Sobre Nós',
    });
  }
}
