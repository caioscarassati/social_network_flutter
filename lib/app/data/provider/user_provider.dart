import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:social_network/app/data/models/user_api_model.dart';

class UserProvider {
  final http.Client httpClient;
  UserProvider({required this.httpClient});

  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<UserApiResponseModel> getUsers({int page = 1}) async {
    final String endpoint = (page == 1) ? '/users' : '/users?page=$page';
    final Uri url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await httpClient.get(url);

      if (response.statusCode == 200) {
        return userApiResponseModelFromJson(response.body);
      } else {
        throw Exception('Falha ao carregar usuários: Status ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Falha de conexão com o servidor');
    } catch (e) {
      rethrow;
    }
  }
}
