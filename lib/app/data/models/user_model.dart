import 'package:hive/hive.dart';

part 'user_model.g.dart'; // Este ficheiro será gerado pelo build_runner

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String password; // Numa app real, isto seria uma hash

  @HiveField(3)
  late String name;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
  });
}
