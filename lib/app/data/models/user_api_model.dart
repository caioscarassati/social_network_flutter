import 'dart:convert';

// Função para decodificar a resposta completa da API
UserApiResponseModel userApiResponseModelFromJson(String str) =>
    UserApiResponseModel.fromJson(json.decode(str));

// Modelo para a resposta completa, incluindo paginação
class UserApiResponseModel {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<UserApiModel> data;

  UserApiResponseModel({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory UserApiResponseModel.fromJson(Map<String, dynamic> json) =>
      UserApiResponseModel(
        page: json["page"],
        perPage: json["per_page"],
        total: json["total"],
        totalPages: json["total_pages"],
        data: List<UserApiModel>.from(
            json["data"].map((x) => UserApiModel.fromJson(x))),
      );
}

// Modelo para um único usuário (sem alterações)
class UserApiModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  UserApiModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) => UserApiModel(
    id: json["id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    avatar: json["avatar"],
  );
}
