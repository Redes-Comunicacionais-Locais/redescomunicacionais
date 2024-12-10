import 'package:redescomunicacionais/app/data/model/user_model.dart';
import 'package:redescomunicacionais/app/data/provider/sign_in.dart';

class LoginRepository {
  final SignInService signInService = SignInService();

  Future<UserModel?> signInGoogle(){
    return signInService.signInGoogle();
  }

  Future<UserModel?> trySignInGoogle(){
    return signInService.trySignInGoogle();
  }
}