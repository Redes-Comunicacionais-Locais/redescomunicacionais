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

  UserModel currentUser = UserModel.empty();

  @override
  Future<void> onInit() async {
    await loadCurrentUserData();
    super.onInit();
  }

  Future<void> loadCurrentUserData() async {
    try {
      isDataLoading.value = true;
      UserModel user = await _repository.getCurrentUser();

      if (isClosed) {
        return;
      }

      currentUser = user;
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
    if (currentUser.name == null || currentUser.name!.trim().isEmpty) {
      PopUps.snackbar(
        texto: 'Informe um nome válido.',
        cor: Colors.orange,
      );
      return;
    }

    try {
      isSavingData.value = true;

      await _repository.updateUserName(
        currentUser.id,
        currentUser.name!.trim(),
      );

      currentUser = await _repository.getCurrentUser();

      if (isClosed) {
        return;
      }

    } catch (e) {
      PopUps.snackbar(
        texto: 'Não foi possível atualizar o nome: $e',
        cor: Colors.red,
      );
    } finally {
      isSavingData.value = false;
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
