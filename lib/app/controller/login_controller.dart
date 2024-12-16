import 'package:get/get.dart';
import 'package:redescomunicacionais/app/data/repository/login_repository.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final LoginRepository repository = LoginRepository();

  void loginGoogle() async {
  try {
    repository.logoutGoogle();
    final user = await repository.signInGoogle();
    if (user != null) {
      Get.offNamed(Routes.HOME, arguments: user);
    } else {
      Get.snackbar(
        "Erro de Login",
        "Falha ao autenticar o usuário.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    Get.snackbar(
      "Erro de Login 2",
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}


  tryLogin() async {
    var hasLogged = await repository.trySignInGoogle();
    if (hasLogged != null) {
      Get.offNamed(Routes.HOME, arguments: hasLogged);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }
  void logout(){
    repository.logoutGoogle();
    Get.offAllNamed(Routes.LOGIN);
  }
}
