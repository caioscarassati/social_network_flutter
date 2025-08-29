import 'package:hive/hive.dart';

part 'user_cache_model.g.dart'; // Ficheiro a ser gerado pelo build_runner

@HiveType(typeId: 1)
class UserCacheModel extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String firstName;

  @HiveField(3)
  late String lastName;

  @HiveField(4)
  late String avatar;

  //  Permite que o valor seja nulo ---
  @HiveField(5)
  bool? isFavorite;

  UserCacheModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    this.isFavorite = false,
  });
}