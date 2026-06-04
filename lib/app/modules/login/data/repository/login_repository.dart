import 'package:redescomunicacionais/app/modules/login/data/provider/sign_in_apple.dart';
import 'package:redescomunicacionais/app/modules/user/data/model/user_model.dart';
import 'package:redescomunicacionais/app/modules/login/data/provider/sign_in.dart';
import 'package:redescomunicacionais/app/modules/user/data/provider/user_provider.dart';

class LoginRepository {
  final SignInService signInService = SignInService();
  final SignInApple signInApple = SignInApple();
  final UserProvider userProvider = UserProvider();

  Future<void> signInGoogle() {
    return signInService.signInGoogle();
  }

  Future<void> trySignInGoogle() {
    return signInService.trySignInGoogle();
  }

  Future<void> logoutGoogle() {
    return signInService.logoutGoogle();
  }

  Future<void> signInMicrosoft() async {
    return signInService.signInMicrosoft();
  }

  Future<void> trySignInMicrosoft() {
    return signInService.trySignInMicrosoft();
  }

  Future<void> logoutMicrosoft() {
    return signInService.logoutMicrosoft();
  }

  Future<void> signInAppleAuth() async {
    return await signInApple.signInWithApple();
  }

  Future<void> createUserDocInHive(UserModel user) async {
    return await userProvider.createUserDocInHive(user);
  }
}
