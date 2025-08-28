import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:social_network/app/data/models/login_response_model.dart';

class AuthProvider {
  final http.Client httpClient;
  AuthProvider({required this.httpClient});

  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  // Método para realizar o login
  Future<LoginResponseModel> login(String email, String password) async {
    final Uri url = Uri.parse('$_baseUrl/login');
    try {
      final response = await httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return loginResponseModelFromJson(response.body);
      } else {
        // Lança uma exceção para ser tratada no Controller
        throw Exception('error_login_failed');
      }
    } on SocketException {
      throw Exception('Falha de conexão');
    } catch (e) {
      rethrow;
    }
  }
}
