import 'package:get/get.dart';
import 'package:redescomunicacionais/app/data/repository/user_repository.dart';

class UserController extends GetxController {
  final UserRepository _repository = UserRepository();
  var isAdmin = false.obs;
  var isSuperAdmin = false.obs;

  Future<void> loadUserRole(String email) async {
    final role = await _repository.getUserRole(email);
    if (role == UserRole.admin) {
      isAdmin.value = true;
    } else if (role == UserRole.superAdmin) {
      isSuperAdmin.value = true;
    }
    
  }
}
