import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:redescomunicacionais/app/modules/user/data/model/user_model.dart';

enum UserRole { user, admin, editor }

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> createUserDoc(
      String email, String name, String uid, String urlImage) async {
    UserModel user = UserModel(
      id: uid,
      name: name,
      email: email,
      urlImage: urlImage,
      role: 'user',
      createdAt: DateTime.now(),
      status: 'active',
    );

    await createUserDocInFirebase(user);
    await createUserDocInHive(user);

    return user;
  }

  Future<void> createUserDocInFirebase(UserModel user) async {
    DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.id).get();
    if (doc.exists) return; // Evita sobrescrever se já existir

    // Cria o documento do usuário no Firestore
    await _firestore.collection('users').doc(user.id).set({
      'name': user.name,
      'email': user.email,
      'role': user.role,
      'createdAt': user.createdAt,
      'roleUpdatedAt': user.roleUpdatedAt,
      'roleUpdatedBy': user.roleUpdatedBy,
      'status': user.status,
      'statusUpdatedAt': user.statusUpdatedAt,
      'statusUpdatedBy': user.statusUpdatedBy,
      'statusObservation': user.statusObservation,
    });
  }

  Future<void> createUserDocInHive(UserModel user) async {
    var box = await Hive.openBox<UserModel>('users');
    try {
      await box.put(user.id, user);
    } catch (e) {
      throw Exception("Erro ao criar usuário no Hive: $e");
    }
  }

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
