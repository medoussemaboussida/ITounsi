import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _passwordVisible = false;
  late GlobalKey<FormState> _formKey;
  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                    offset: Offset(0, 4), // décalage de l'ombre
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ajuste la hauteur en fonction du contenu
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(File(_profileImage!.path))
                              : AssetImage('assets/dbz.png') as ImageProvider,
                          child: _profileImage == null
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
                            labelText: "New Username",
                            labelStyle: TextStyle(color: Colors.black87, fontSize: 12),
                            fillColor: Colors.blueGrey.shade200,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Username field is required')
                          ]),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: "New Password",
                            labelStyle: TextStyle(color: Colors.black87, fontSize: 12),
                            fillColor: Colors.blueGrey.shade200,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Password field is required'),
                            MaxLengthValidator(20, errorText: 'Maximum length is 20 !'),
                            MinLengthValidator(8, errorText: 'Minimum length is 8 !'),
                          ]),
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
                          // Action de mise à jour
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Color(0xFF0088cc)),
                        iconSize: 30,
                        onPressed: () {
                          // Action de suppression
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Color(0xFF0088cc)),
                        iconSize: 30,
                        onPressed: () {
                          // Action de déconnexion
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
