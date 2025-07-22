class UserModel {
  String? id;
  String? name;
  String email;
  String? urlImage;

  UserModel({this.id, this.name, required this.email, this.urlImage});

  factory UserModel.fromFirebase(user) {
    // Verifica se é GoogleSignInAccount ou Firebase User
    if (user.runtimeType.toString().contains('GoogleSignInAccount')) {
      // Google Sign In Account
      return UserModel(
        id: user.id,
        name: user.displayName ?? '',
        email: user.email ?? '',
        urlImage: user.photoUrl ?? '',
      );
    } else {
      // Firebase User (Microsoft, etc.)
      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        urlImage: user.photoURL ?? '',
      );
    }
  }

  get photoUrl => null;
}
