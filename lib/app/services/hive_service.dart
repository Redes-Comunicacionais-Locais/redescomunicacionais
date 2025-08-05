import 'package:hive_flutter/hive_flutter.dart';
import 'package:redescomunicacionais/app/data/model/user_model.dart';

class HiveInitializer {
  static Future<void> initialize() async {
    await Hive.initFlutter(); // Inicializa o Hive
    print('Hive initialized');

    Hive.registerAdapter(UserModelAdapter());

    // Tabelas
    await Hive.openBox<UserModel>('users');
  }
}
