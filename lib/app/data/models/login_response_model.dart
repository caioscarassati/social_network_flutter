import 'dart:convert';

// Função para decodificar o JSON de resposta do login
LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

// Modelo de dados para a resposta da API de login
class LoginResponseModel {
  final String token;

  LoginResponseModel({
    required this.token,
  });

  // Factory constructor para criar uma instância a partir de um mapa JSON
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        token: json["token"],
      );
}
