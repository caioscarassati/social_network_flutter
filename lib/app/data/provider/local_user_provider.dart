import 'package:hive/hive.dart';
import 'package:social_network/app/data/models/user_model.dart';

class LocalUserProvider {
  static const String _userBoxName = 'users';

  // Obtém um utilizador pelo e-mail
  Future<User?> getUserByEmail(String email) async {
    final box = await Hive.openBox<User>(_userBoxName);
    // Procura na box por um utilizador com o e-mail correspondente
    final user = box.values.cast<User?>().firstWhere(
          (user) => user?.email == email,
      orElse: () => null,
    );
    return user;
  }

  // Adiciona um utilizador (usado para popular os dados iniciais)
  Future<void> addUser(User user) async {
    final box = await Hive.openBox<User>(_userBoxName);
    // A chave será o ID do utilizador para fácil acesso
    await box.put(user.id, user);
  }

  // Verifica se a box de utilizadores está vazia
  Future<bool> isUserBoxEmpty() async {
    final box = await Hive.openBox<User>(_userBoxName);
    return box.isEmpty;
  }
}
