import 'package:test_first/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<User>> fetchUsers() async {
  try {
    final response = await http.get(Uri.parse('http://192.168.1.46:5000/auth/getAllUsers'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('Response data: $data'); // Affichez les données pour vérifier le format
      
      // Vérifiez les clés et les types
      if (data.containsKey('users') && data['users'] is List) {
        final List<dynamic> usersJson = data['users'];
        return usersJson.map((json) {
          if (json is Map<String, dynamic>) {
            return User.fromJson(json);
          } else {
            throw Exception('Un élément de la liste des utilisateurs n\'est pas un Map');
          }
        }).toList();
      } else {
        throw Exception('La clé "users" est absente ou n\'est pas une liste');
      }
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Failed to load users: $e');
  }
}

