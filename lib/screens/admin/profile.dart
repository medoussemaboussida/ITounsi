import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_first/screens/widget/users_widget.dart';
import 'package:test_first/models/user.dart';

Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('http://192.168.1.22:5000/auth/getAllUsers'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    print(data); // Affichez les données pour vérifier le format

    // Assurez-vous que la clé utilisée est correcte
    final List<dynamic> usersJson = data['usersList'] ?? [];
    return usersJson.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserWidget(user: users[index]);
              },
            );
          }
        },
      ),
    );
  }
}
