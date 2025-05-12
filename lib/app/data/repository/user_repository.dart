import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { user, admin, editor }

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addProfile(String email, String profile) async {
    try {
      if (profile == 'admin') {
        await _firestore.collection('admin').doc(email).set({});
      } else if (profile == 'editor') {
        await _firestore.collection('editor').doc(email).set({});
      }
    } catch (e) {
      throw Exception("Erro ao criar admin vazio: $e");
    }
  }

  Future<UserRole> getUserRole(String email) async {
    final isEditor = await _firestore.collection('editor').doc(email).get();
    if (isEditor.exists) return UserRole.editor;

    final isAdmin = await _firestore.collection('admin').doc(email).get();
    if (isAdmin.exists) return UserRole.admin;

    return UserRole.user;
  }
}
