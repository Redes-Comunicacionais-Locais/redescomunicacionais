import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { user, admin, superAdmin }

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserRole> getUserRole(String email) async {
    final isSuperAdmin = await _firestore.collection('super_admin').doc(email).get();
    if (isSuperAdmin.exists) return UserRole.superAdmin;

    final isAdmin = await _firestore.collection('admin').doc(email).get();
    if (isAdmin.exists) return UserRole.admin;

    return UserRole.user;
  }
}
