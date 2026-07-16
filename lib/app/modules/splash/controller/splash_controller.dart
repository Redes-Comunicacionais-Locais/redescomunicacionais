import 'package:get/get.dart';
import 'package:redescomunicacionais/app/modules/login/controller/login_controller.dart';
import 'package:redescomunicacionais/app/services/update_version_service.dart';

class SplashController extends GetxController {
  late final LoginController _loginController;
  final UpdateVersionService _updateService = UpdateVersionService();

  @override
  void onInit() {
    _loginController = Get.find<LoginController>();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _checkAppUpdate();
  }

  Future<void> _checkAppUpdate() async {
    await _updateService.initialize();

    if (Get.context != null) {
      await _updateService.checkForUpdates(Get.context!);
    }
    _loginController.tryLogin();
  }
}
