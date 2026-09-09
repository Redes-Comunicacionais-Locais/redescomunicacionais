import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';
import 'package:redescomunicacionais/app/modules/news/controller/news_controller.dart';
import 'package:redescomunicacionais/app/modules/dashboard/controller/home_controller.dart';
import 'package:redescomunicacionais/app/modules/news/utils/categories.dart';
import 'package:redescomunicacionais/app/modules/news/utils/cities_codes.dart';
import 'package:redescomunicacionais/app/modules/news/utils/news_types.dart';
import 'package:redescomunicacionais/app/services/image_base64_service.dart';
import 'package:redescomunicacionais/app/modules/news/utils/news_states.dart';
import 'package:redescomunicacionais/app/utils/components/popups.dart';
import 'package:redescomunicacionais/app/modules/news/ui/publication_terms_dialog.dart';
import 'package:redescomunicacionais/app/modules/news/ui/publication_opinion_terms_dialog.dart';

class CreateNewsFormController extends GetxController {
  late final HomeController _homeController;
  late final NewsController _newsController;
  late final ImageBase64Service _imageController;
  late QuillController _bodyController;

  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _videoUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  TextEditingController get titleController => _titleController;
  TextEditingController get subtitleController => _subtitleController;
  QuillController get bodyController => _bodyController;
  TextEditingController get videoUrlController => _videoUrlController;
  ImageBase64Service get imageController => _imageController;
  GlobalKey<FormState> get formKey => _formKey;

  List<String> get selectedCategories => _selectedCategories;
  List<String> get selectedCities => _selectedCities;
  String? get type => _type.value;

  bool get showCategoryError => _showCategoryError.value;
  bool get showCityError => _showCityError.value;
  bool get showTypeError => _showTypeError.value;

  final _selectedCategories = <String>[].obs;
  final _selectedCities = <String>[].obs;
  final _type = Rxn<String>();

  final _showCategoryError = false.obs;
  final _showCityError = false.obs;
  final _showTypeError = false.obs;

  final List<String> categories = Categories().categories;

  final List<String> cities = CitiesCodes().cities.values.toList();

  final List<String> types = NewsTypes().types;

  @override
  void onInit() {
    super.onInit();
    _bodyController = QuillController.basic();
    _homeController = Get.find<HomeController>();
    _newsController = Get.find<NewsController>();
    _imageController = Get.find<ImageBase64Service>();
  }

  @override
  void onClose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _bodyController.dispose();
    _videoUrlController.dispose();
    super.onClose();
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }

    _showCategoryError.value = false;
  }

  void toggleCity(String city) {
    if (_selectedCities.contains(city)) {
      _selectedCities.remove(city);
    } else {
      _selectedCities
        ..clear()
        ..add(city);
    }

    _showCityError.value = false;
  }

  void toggleType(String selectedType) {
    if (_type.value == selectedType) {
      _type.value = null;
    } else {
      _type.value = selectedType;
    }

    _showTypeError.value = false;
  }

  Future<void> validateAndPublish(bool draft) async {
    if (draft) {
      await _publishNews(draft);
      return;
    }

    _showCategoryError.value = _selectedCategories.isEmpty;
    _showCityError.value = _selectedCities.isEmpty;
    _showTypeError.value = _type.value == null;


if (_formKey.currentState!.validate() &&
_selectedCategories.isNotEmpty &&
_selectedCities.isNotEmpty &&
_type.value != null) {


  final Map<String, dynamic>? terms;

  if (_type.value == 'Opinião') {
    terms = await Get.dialog<Map<String, dynamic>>(
      const PublicationOpinionTermsDialog(),
    );
  } else {
    terms = await Get.dialog<Map<String, dynamic>>(
      const PublicationTermsDialog(),
    );
  }


      if (terms != null) {
        await _publishNews(
          draft,
          publicationTerms: terms,
        );
      }
    } else {
      PopUps.snackbar(
        texto: 'Por favor, preencha todos os campos obrigatórios.'.tr,
        cor: Colors.red,
      );
    }
  }

  Future<void> _publishNews(
    bool draft, {
    Map<String, dynamic>? publicationTerms,
  }) async {
    final String title = _titleController.text;
    final String subtitle = _subtitleController.text;
    final String body = _getBodyText();

    List<String> urlImages = [_imageController.base64String ?? ""];

    final String author = _homeController.user.name!;
    final String email = _homeController.user.email;
    final String videoUrl = _videoUrlController.text;

    final String newsState = draft ? NewsStates.rascunho : NewsStates.emAnalise;

    try {
      String newsId = await _newsController.addNews(
        title,
        subtitle,
        _selectedCities.toList(),
        _selectedCategories.toList(),
        body,
        urlImages,
        author,
        email,
        _type.value ?? '',
        newsState,
        videoUrl,
      );

      // Salva os termos somente quando for publicação
      if (!draft && publicationTerms != null) {
        await _newsController.savePublicationTerms(
          newsId: newsId,
          terms: {
            ...publicationTerms,
            "acceptedAll": true,
            "author": email,
            "acceptedAt": DateTime.now(),
          },
        );
      }

      if (draft) {
        PopUps.snackbar(
          texto: 'Rascunho salvo com sucesso!'.tr,
          cor: Colors.green,
        );
      } else {
        PopUps.snackbar(
          texto: 'Matéria enviada para análise com sucesso!'.tr,
          cor: Colors.green,
        );
      }
    } catch (e) {
      if (draft) {
        PopUps.snackbar(
          texto: 'Erro ao salvar rascunho'.tr,
          cor: Colors.red,
        );
      } else {
        PopUps.snackbar(
          texto: 'Erro ao publicar matéria'.tr,
          cor: Colors.red,
        );
      }

      return;
    }

    _clearForm();

    Get.back();
  }

  void _clearForm() {
    _titleController.clear();
    _subtitleController.clear();

    _bodyController.clear();

    _selectedCategories.clear();
    _selectedCities.clear();

    _type.value = null;

    _showCategoryError.value = false;
    _showCityError.value = false;
    _showTypeError.value = false;
  }

  String _getBodyText() {
    return jsonEncode(
      _bodyController.document.toDelta().toJson(),
    );
  }

}
