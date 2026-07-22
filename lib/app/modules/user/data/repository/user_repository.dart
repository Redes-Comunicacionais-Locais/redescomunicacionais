import 'package:redescomunicacionais/app/modules/user/data/model/user_model.dart';
import 'package:redescomunicacionais/app/modules/user/data/provider/user_provider.dart';
import 'package:redescomunicacionais/app/services/keys_services/public_key_model.dart';

class UserRepository {
  UserRepository();
  final UserProvider _userProvider = UserProvider();

  Future<void> createUserDoc(
      String email, String name, String uid, String urlImage) {
    return _userProvider.createUserDoc(email, name, uid, urlImage);
  }

  Future<void> updateRole(String userId, String role, String adminEmail) {
    return _userProvider.updateUserRole(userId, role, adminEmail);
  }

  Future<List<UserModel>> getAllUsers() {
    return _userProvider.getAllUsers();
  }

  Future<UserModel> getCurrentUser() {
    return _userProvider.getCurrentUserFromHive();
  }

  Future<void> updateUserInHive(UserModel user) {
    return _userProvider.updateUserInHive(user);
  }

  Future<void> deleteCurrentUserFromHive() {
    return _userProvider.deleteCurrentUserFromHive();
  }

  Future<void> deleteCurrentUserAccount() {
    return _userProvider.deleteCurrentUserAccount();
  }

  Future<void> updateUserName(String userId, String name) {
    return _userProvider.updateUserName(userId, name);
  }

  Future<String?> getPrivateKeyInStorage() async {
    return await _userProvider.getPrivateKeyInStorage();
  }

  Future<void> createPublicKeyInFirebase(PublicKeyModel publicKeyModel) async {
    return _userProvider.createPublicKeyInFirebase(publicKeyModel);
  }
}
