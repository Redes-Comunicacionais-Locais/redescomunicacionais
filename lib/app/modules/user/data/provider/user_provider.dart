import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:redescomunicacionais/app/modules/user/data/model/user_model.dart';
import 'package:redescomunicacionais/app/modules/user/utils/userRoles.dart';

class UserProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Armazena sempre na mesma chave para garantir apenas uma entrada
  final String hiveUserKey = 'current_user';
  final String userCollection = 'users';

  Future<UserModel> createUserDoc(
      String email, String name, String uid, String urlImage) async {
    UserModel userHive = UserModel.empty();
    UserModel userFirebase = UserModel.empty();

    UserModel newUser = UserModel(
      id: uid,
      name: name,
      email: email,
      urlImage: urlImage,
      role: UserRoles.user,
      createdAt: DateTime.now(),
      status: 'active',
    );

    try {
      userFirebase = await _getCurrentUserFromFirebase(uid);
    } catch (e) {
      debugPrint("Usuário não encontrado no Firebase");
    }

    try {
      userHive = await getCurrentUserFromHive();
    } catch (e) {
      debugPrint("Usuário não encontrado no Hive");
    }

    UserModel selectedUser =
        await _selectUpdatedUser(userFirebase, userHive, newUser);

    try {
      await _createUserDocInFirebase(selectedUser, name, urlImage);
    } catch (e) {
      throw Exception("Erro ao criar documento no Firebase: $e");
    }

    try {
      await createUserDocInHive(selectedUser);
    } catch (e) {
      debugPrint("Erro ao criar documento no Hive: $e");
    }
    try {
      await _updateBasicInformations(selectedUser, name, urlImage);
    } catch (e) {
      throw Exception("Erro ao atualizar informações básicas do usuário: $e");
    }

    return selectedUser;
  }

  Future<void> _createUserDocInFirebase(
      UserModel user, String name, String urlImage) async {
    try {
      final newUser = UserModel(
        id: user.id,
        urlImage: urlImage,
        name: name,
        email: user.email,
        role: user.role,
        createdAt: user.createdAt,
        roleUpdatedAt: user.roleUpdatedAt,
        roleUpdatedBy: user.roleUpdatedBy,
        status: user.status,
        statusUpdatedAt: user.statusUpdatedAt,
        statusUpdatedBy: user.statusUpdatedBy,
        statusObservation: user.statusObservation,
        lastUpdated: DateTime.now(),
      );
      try {
        await _firestore
            .collection(userCollection)
            .doc(user.id)
            .set(newUser.toJson(), SetOptions(merge: true));
      } catch (e) {
        throw Exception("Erro ao criar usuário do Firebase: $e");
      }
    } catch (e) {
      throw Exception("Erro ao criar usuário do Firebase: $e");
    }
  }

  Future<void> createUserDocInHive(UserModel user) async {
    try {
      var box = await Hive.openBox<UserModel>(userCollection);

      // Verifica se a chave já existe

      await box.put(hiveUserKey, user);
      await box.flush(); // Força a escrita no disco
    } catch (e) {
      throw Exception("Erro ao criar usuário no Hive: $e");
    }
  }

  Future<UserModel> getCurrentUserFromHive() async {
    try {
      var box = await Hive.openBox<UserModel>(userCollection);

      if (!box.containsKey(hiveUserKey)) {
        throw Exception("Nenhum usuário encontrado no Hive");
      }

      UserModel user = box.get(hiveUserKey)!;

      debugPrint("Usuário recuperado do Hive:");

      return user;
    } catch (e) {
      throw Exception("Erro ao recuperar usuário do Hive: $e");
    }
  }

  Future<UserModel> _getCurrentUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(userCollection).doc(uid).get();

      if (!doc.exists) {
        throw Exception("Nenhum usuário encontrado no Firebase");
      }

      UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      debugPrint("Usuário recuperado do Firebase: ${user.name}");
      return user;
    } catch (e) {
      throw Exception("Erro ao recuperar usuário do Firebase: $e");
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(userCollection).get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        userData['id'] = doc.id;

        return UserModel.fromJson(userData);
      }).toList();
    } catch (e) {
      throw Exception("Erro ao buscar usuários: $e");
    }
  }

  Future<void> deleteCurrentUserFromHive() async {
    try {
      final box = await Hive.openBox<UserModel>(userCollection);

      if (box.containsKey(hiveUserKey)) {
        await box.delete(hiveUserKey);
        await box.flush();
        debugPrint("Usuário removido do Hive com sucesso");
      } else {
        debugPrint("Nenhum usuário encontrado no Hive para remover");
      }
    } catch (e) {
      debugPrint("Erro ao remover usuário do Hive: $e");
      throw Exception("Erro ao remover usuário do Hive: $e");
    }
  }

  Future<void> deleteCurrentUserAccount() async {
    final currentFirebaseUser = _auth.currentUser;
    final currentUserFromHive = await getCurrentUserFromHive();

    final String uid = currentFirebaseUser?.uid.isNotEmpty == true
        ? currentFirebaseUser!.uid
        : currentUserFromHive.id;

    if (uid.isEmpty) {
      throw Exception('Não foi possível identificar a conta para exclusão.');
    }

    if (currentFirebaseUser == null) {
      throw Exception(
          'Usuário não autenticado no Firebase. Faça login novamente.');
    }

    try {
      await _firestore.collection('roles').doc(uid).delete();
      await _firestore.collection(userCollection).doc(uid).delete();
      await currentFirebaseUser.delete();
      await deleteCurrentUserFromHive();
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception(
            'Por segurança, faça login novamente antes de excluir sua conta.');
      }
      throw Exception('Erro ao excluir conta: ${e.message ?? e.code}');
    }
  }

  Future<void> _updateBasicInformations(
      UserModel selectedUser, String name, String urlImage) async {
    if (selectedUser.status == 'anonymous') {
      return;
    } else if (selectedUser.name != name || selectedUser.urlImage != urlImage) {
      UserModel updatedUser = UserModel(
        id: selectedUser.id,
        name: name,
        email: selectedUser.email,
        urlImage: urlImage,
        role: selectedUser.role,
        createdAt: selectedUser.createdAt,
        roleUpdatedAt: selectedUser.roleUpdatedAt,
        roleUpdatedBy: selectedUser.roleUpdatedBy,
        status: selectedUser.status,
        statusUpdatedAt: selectedUser.statusUpdatedAt,
        statusUpdatedBy: selectedUser.statusUpdatedBy,
        statusObservation: selectedUser.statusObservation,
        lastUpdated: DateTime.now(),
      );

      await updateUserInHive(updatedUser);

      return;
    }
  }

  Future<void> updateUserRole(
      String userId, String role, String adminEmail) async {
    try {
      final docRef = _firestore.collection(userCollection).doc(userId);

      await docRef.update({
        'role': role,
        'roleUpdatedAt': FieldValue.serverTimestamp(),
        'roleUpdatedBy': adminEmail,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      DocumentSnapshot updatedDoc = await docRef.get();
      UserModel updatedUser =
          UserModel.fromMap(updatedDoc.data() as Map<String, dynamic>);
      _updateUserRoleinRoles(userId, role, adminEmail);
      updateUserInHive(updatedUser);
    } catch (e) {
      throw Exception("Erro ao atualizar e recuperar usuário: $e");
    }
  }

  Future<void> _updateUserRoleinRoles(
      String userId, String role, String adminEmail) async {
    try {
      final docRef = _firestore.collection('roles').doc(userId);

      await docRef.set({
        'userId': userId,
        'role': role,
        'roleUpdatedAt': FieldValue.serverTimestamp(),
        'roleUpdatedBy': adminEmail,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Erro ao atualizar e recuperar usuário: $e");
    }
  }

  Future<void> updateUserInHive(UserModel user) async {
    try {
      var box = await Hive.openBox<UserModel>(userCollection);

      await box.put(hiveUserKey, user);
      await box.flush(); // Força a escrita no disco

      return;
    } catch (e) {
      debugPrint("Erro ao atualizar usuário no Hive: $e");
      throw Exception("Erro ao atualizar usuário no Hive: $e");
    }
  }

  Future<void> updateUserName(String userId, String name) async {
    try {
      final docRef = _firestore.collection(userCollection).doc(userId);

      await docRef.update({
        'name': name,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      DocumentSnapshot updatedDoc = await docRef.get();
      UserModel updatedUser =
          UserModel.fromMap(updatedDoc.data() as Map<String, dynamic>);
      updateUserInHive(updatedUser);
    } catch (e) {
      throw Exception("Erro ao atualizar e recuperar usuário: $e");
    }
  }

  Future<UserModel> _selectUpdatedUser(
      UserModel userFirebase, UserModel userHive, UserModel newUser) async {
    if (userFirebase.status == 'anonymous' && userHive.status == 'anonymous') {
      return newUser;
    } else if (userFirebase.status != 'anonymous' &&
        userHive.status == 'anonymous') {
      return userFirebase;
    } else if (userFirebase.status == 'anonymous' &&
        userHive.status != 'anonymous') {
      return userHive;
    } else {
      if (userFirebase.lastUpdated != null && userHive.lastUpdated == null) {
        return userFirebase;
      } else if (userFirebase.lastUpdated == null &&
          userHive.lastUpdated != null) {
        return userHive;
      } else if (userFirebase.lastUpdated != null &&
          userHive.lastUpdated != null) {
        if (userFirebase.lastUpdated!.isAfter(userHive.lastUpdated!)) {
          return userFirebase;
        } else {
          return userHive;
        }
      } else {
        UserModel userWithTimestamp = UserModel(
          id: userFirebase.id,
          name: userFirebase.name,
          email: userFirebase.email,
          urlImage: userFirebase.urlImage,
          role: userFirebase.role,
          createdAt: userFirebase.createdAt,
          roleUpdatedAt: userFirebase.roleUpdatedAt,
          roleUpdatedBy: userFirebase.roleUpdatedBy,
          status: userFirebase.status,
          statusUpdatedAt: userFirebase.statusUpdatedAt,
          statusUpdatedBy: userFirebase.statusUpdatedBy,
          statusObservation: userFirebase.statusObservation,
          lastUpdated: DateTime.now(),
        );
        return userWithTimestamp;
      }
    }
  }
}
