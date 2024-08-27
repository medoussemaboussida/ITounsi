import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_first/screens/admin/updatePassword.dart';
import 'package:test_first/screens/signin.dart';

class ProfileAdmin extends StatefulWidget {
  const ProfileAdmin({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileAdmin> {
  late TextEditingController _usernameController;
  late TextEditingController _dobController;
  late GlobalKey<FormState> _formKey;
  XFile? _profileImage;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _dobController = TextEditingController();

    _loadUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://192.168.1.27:5000/auth/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _usernameController.text = data['username'];
            // Formater la date ici
            DateTime dob = DateTime.parse(data['dob']);
            _dobController.text =
                "${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}";
            _profileImageUrl = data['user_photo'] != null
                ? 'http://192.168.1.27:5000/images/${data['user_photo']}'
                : null;
          });
        } else {
          print('Failed to load user profile: ${response.body}');
        }
      } catch (e) {
        print('Error fetching user profile: $e');
      }
    }
  }

  Future<void> _updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token != null) {
      try {
        final request = http.MultipartRequest(
          'PUT',
          Uri.parse('http://192.168.1.27:5000/auth/updateProfile'),
        );
        request.headers['Authorization'] = 'Bearer $token';

        // Ajouter toutes les valeurs existantes, même si elles ne sont pas modifiées
        request.fields['username'] = _usernameController.text.isNotEmpty
            ? _usernameController.text
            : _usernameController.text;
        request.fields['dob'] = _dobController.text.isNotEmpty
            ? _dobController.text
            : _dobController.text;

        if (_profileImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'user_photo',
            _profileImage!.path,
          ));
        }

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          print('Profile updated successfully');
          setState(() {
            if (_profileImage != null) _profileImage = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          print('Failed to update profile: ${response.reasonPhrase}');
          print('Response body: $responseBody');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update profile!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error updating profile: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        appBar: AppBar(
          title: Text('Update Profile'),
          backgroundColor: Colors.blueGrey.shade100,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(File(_profileImage!.path))
                              : _profileImageUrl != null
                                  ? NetworkImage(_profileImageUrl!)
                                      as ImageProvider
                                  : null,
                          child:
                              _profileImage == null && _profileImageUrl == null
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.black,
                                    )
                                  : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              backgroundColor: Color(0xFF0088cc),
                              radius: 15,
                              child: Icon(
                                Icons.camera_alt,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle:
                                TextStyle(color: Colors.black87, fontSize: 12),
                            fillColor: Colors.blueGrey.shade200,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'Username field is required')
                          ]),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _dobController,
                          decoration: InputDecoration(
                            labelText: "Date of Birth",
                            labelStyle:
                                TextStyle(color: Colors.black87, fontSize: 12),
                            fillColor: Colors.blueGrey.shade200,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                // Formater la date au format ISO 8601: YYYY-MM-DD
                                _dobController.text = pickedDate
                                    .toIso8601String()
                                    .split('T')
                                    .first;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.update, color: Color(0xFF0088cc)),
                        iconSize: 30,
                        onPressed: () {
                          _updateProfile();
                        }, // Action de mise à jour
                      ),
                         IconButton(
                        icon: Icon(Icons.password, color: Color(0xFF0088cc)),
                        iconSize: 30,
                        onPressed: () { Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => UpdatePassword()),
    );
                          // Action de suppression
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Color(0xFF0088cc)),
                        iconSize: 30,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(builder: (context) => Signin()),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
