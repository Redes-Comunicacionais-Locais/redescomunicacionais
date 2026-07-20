import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/modules/user/data/model/user_model.dart';
import 'package:redescomunicacionais/app/modules/user/data/repository/user_repository.dart';
import 'package:redescomunicacionais/app/modules/login/data/repository/login_repository.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/utils/components/popups.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginController extends GetxController {
  final LoginRepository _repository = LoginRepository();
  final UserRepository _userRepository = UserRepository();

  final RxString appVersion = 'Carregando...'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
    } catch (_) {
      appVersion.value = '--';
    }
  }

  void loginGoogle() async {
    try {
      await _repository.logoutGoogle();
      await _repository.signInGoogle();
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      debugPrint("Erro de Login: $e");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.context != null) {
          PopUps.snackbar(
            texto:
                'Ocorreu um erro ao tentar fazer login com o Google. Por favor, tente novamente.'
                    .tr,
            cor: Colors.red,
          );
        }
      });
    }
  }

  void loginMicrosoft() async {
    try {
      await _repository.logoutGoogle();
      await _repository.logoutMicrosoft();
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      debugPrint("Erro de Login Microsoft: $e");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.context != null) {
          PopUps.snackbar(
            texto:
                "Ocorreu um erro ao tentar fazer login com o Microsoft. Por favor, tente novamente."
                    .tr,
            cor: Colors.red,
          );
        }
      });
    }
  }

  Future<void> tryLogin() async {
    try {
      await _repository.trySignInGoogle().timeout(const Duration(seconds: 10),
          onTimeout: () =>
              throw Exception("Tempo esgotado para login silencioso"));

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      debugPrint("Erro no tryLogin: $e");
      loginAnonymous();
    }
  }

  Future<void> tryLoginMicrosoft() async {
    try {
      await _repository.trySignInMicrosoft();
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      debugPrint("Erro no tryLoginMicrosoft: $e");
      loginAnonymous();
    }
  }

  void logout() async {
    await _repository.logoutMicrosoft();
    await _repository.logoutGoogle();
    await _userRepository.deleteCurrentUserFromHive();
    Get.offAllNamed(Routes.LOGIN);
  }

  void loginApple() async {
    try {
      await _repository.logoutGoogle();
      await _repository.logoutMicrosoft();
      await _repository.signInAppleAuth();
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      debugPrint("Erro de Login Apple: $e");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.context != null) {
          PopUps.snackbar(
            texto:
                'Ocorreu um erro ao tentar fazer login com o Apple. Por favor, tente novamente.'
                    .tr,
            cor: Colors.red,
          );
        }
      });
    }
  }

  void loginAnonymous() async {
    await _repository.logoutGoogle();
    await _repository.logoutMicrosoft();
    UserModel anonymousUser = UserModel.empty();
    await _repository.createUserDocInHive(anonymousUser);
    Get.offAllNamed(Routes.HOME);
  }
}
