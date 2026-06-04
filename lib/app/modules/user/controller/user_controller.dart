import 'package:get/get.dart';
import 'package:redescomunicacionais/app/modules/user/data/model/user_model.dart';
import 'package:redescomunicacionais/app/modules/user/data/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/utils/components/popups.dart';

class UserController extends GetxController {
  final UserRepository _repository = UserRepository();

  RxBool isAdmin = false.obs;
  RxBool isEditor = false.obs;
  RxBool isLoading = false.obs;
  RxBool isDataLoading = true.obs;
  RxBool isSavingData = false.obs;
  RxBool isDeletingAccount = false.obs;

  final TextEditingController nameController = TextEditingController();

  Rxn<UserModel> currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadCurrentUserData();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> loadCurrentUserData() async {
    try {
      isDataLoading.value = true;
      UserModel user = await _repository.getCurrentUser();
      currentUser.value = user;
      nameController.text = user.name ?? '';
    } catch (e) {
      PopUps.snackbar(
        texto: 'Não foi possível carregar seus dados.',
        cor: Colors.red,
      );
    } finally {
      isDataLoading.value = false;
    }
  }

  Future<void> saveCurrentUserName() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      PopUps.snackbar(
        texto: 'Informe um nome válido.',
        cor: Colors.orange,
      );
    } else {
      try {
        isSavingData.value = true;
        await _repository.updateUserName(currentUser.value!.id, name);
        currentUser.value = await _repository.getCurrentUser();

        PopUps.snackbar(
          texto: 'Nome atualizado com sucesso.',
          cor: Colors.green,
        );
      } catch (e) {
        PopUps.snackbar(
          texto: 'Não foi possível atualizar o nome: $e',
          cor: Colors.red,
        );
      } finally {
        isSavingData.value = false;
      }
    }
  }

  Future<void> deleteCurrentUserAccount() async {
    try {
      isDeletingAccount.value = true;
      await _repository.deleteCurrentUserAccount();
      Get.offAllNamed(Routes.LOGIN);
      PopUps.snackbar(
        texto: 'Sua conta foi excluída com sucesso.',
        cor: Colors.green,
      );
    } catch (e) {
      PopUps.snackbar(
        texto: 'Não foi possível excluir a conta: $e',
        cor: Colors.red,
      );
    } finally {
      isDeletingAccount.value = false;
    }
  }
}
