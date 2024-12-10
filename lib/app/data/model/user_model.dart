import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? urlImage;

  UserModel({this.id, this.name, this.email, this.urlImage});

  factory UserModel.fromFirebase(user) {
    return UserModel(
      id: user.id,
      name: user.displayName ?? '',
      email: user.email ?? '',
      urlImage: user.photoUrl ?? '',
    );
    
  }

  get photoUrl => null;
}