import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Pour stocker le token
import 'package:test_first/screens/adminHome.dart';
import 'package:test_first/screens/signin.dart';
import 'package:test_first/screens/visitorHome.dart'; // Importer votre page de connexion

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late TextEditingController _emailController;
  late TextEditingController _codeController;
  late TextEditingController _newPasswordController;
  bool _isCodeSent = false; // Pour vérifier si le code a été envoyé
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _codeController = TextEditingController();
    _newPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        'email': _emailController.text,
      };

      try {
        final response = await http.post(
          Uri.parse('http://192.168.1.34:5000/auth/send-code'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          // Code envoyé avec succès
          setState(() {
            _isCodeSent = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification code sent')),
          );
        } else {
          // Gestion des erreurs
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send verification code')),
          );
        }
      } catch (e) {
        // Gestion des erreurs de requête HTTP
        print('Failed to send verification code: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send verification code')),
        );
      }
    }
  }

  Future<void> _verifyCodeAndLogin() async {
  if (_formKey.currentState!.validate()) {
    final Map<String, dynamic> data = {
      'email': _emailController.text,
      'code': _codeController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.34:5000/auth/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String token = responseData['token'];
        final String role = responseData['role']; // Récupérer le rôle de la réponse

        // Stocker le token dans SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        // Redirection basée sur le rôle
        Widget destination;
        if (role == 'admin') {
          destination = Adminhome();
        } else if (role == 'visitor') {
          destination = Visitorhome();
        } else {
          // Si le rôle n'est pas reconnu, vous pouvez gérer comme vous le souhaitez
          destination = Signin(); // Par exemple
        }

        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => destination),
          (route) => false,
        );
      } else {
        // Gestion des erreurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid code or failed to reset password')),
        );
      }
    } catch (e) {
      // Gestion des erreurs de requête HTTP
      print('Failed to verify code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify code')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blueGrey.shade100,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
                Container(
                  height: 280,
                  width: 280,
                  child: Image.asset("assets/itounsi.png"),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.black87, fontSize: 12),
                    fillColor: Colors.blueGrey.shade200,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: MultiValidator([
                    EmailValidator(errorText: 'Enter a valid email address'),
                    RequiredValidator(errorText: 'Email field is required'),
                  ]),
                ),
                if (_isCodeSent) ...[
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      labelText: "Verification Code",
                      labelStyle: TextStyle(color: Colors.black87, fontSize: 12),
                      fillColor: Colors.blueGrey.shade200,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.code),
                    ),
                    validator: RequiredValidator(errorText: 'Verification code is required'),
                  ),
                ],
                SizedBox(height: 10),
                CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    _isCodeSent ? "Verify Code and Login" : "Send Verification Code",
                    style: TextStyle(color: Colors.blueGrey.shade100),
                  ),
                  color: Color(0xFF0088cc),
                  borderRadius: BorderRadius.circular(40),
                  onPressed: _isCodeSent ? _verifyCodeAndLogin : _sendVerificationCode,
                ),
                Spacer(),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
