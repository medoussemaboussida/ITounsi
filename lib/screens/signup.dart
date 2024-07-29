import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:test_first/screens/signin.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final scrollController = ScrollController();

  @override
  void initState() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password field is required';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Spacer(),
                      Container(
                        height: 200,
                        width: 200,
                        child: Image.asset("assets/itounsi.png"),
                      ),
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
                              errorText: 'Username field is required'),
                          MaxLengthValidator(15,
                              errorText: 'Maximum length is 15 !'),
                          MinLengthValidator(4,
                              errorText: 'Minimum length is 4 !'),
                        ]),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle:
                              TextStyle(color: Colors.black87, fontSize: 12),
                          fillColor: Colors.blueGrey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: MultiValidator([
                          EmailValidator(
                              errorText: 'Enter a valid email address'),
                          RequiredValidator(
                              errorText: 'Email field is required')
                        ]),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle:
                              TextStyle(color: Colors.black87, fontSize: 12),
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
                          RequiredValidator(
                              errorText: 'Password field is required'),
                          MaxLengthValidator(20,
                              errorText: 'Maximum length is 20 !'),
                          MinLengthValidator(8,
                              errorText: 'Minimum length is 8 !'),
                        ]),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_confirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle:
                              TextStyle(color: Colors.black87, fontSize: 12),
                          fillColor: Colors.blueGrey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: _validateConfirmPassword,
                      ),
                      SizedBox(height: 10),
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Create an account",
                          style: TextStyle(color: Colors.blueGrey.shade100),
                        ),
                        color: Color(0xFF0088cc),
                        borderRadius: BorderRadius.circular(40),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print("username = ${_usernameController.text}");
                            print("email = ${_emailController.text}");
                            print("password = ${_passwordController.text}");
                            print(
                                "Confirm password = ${_confirmPasswordController.text}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signin()),
                            );
                          } else {
                            print("error !");
                          }
                        },
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                              height: 1.5,
                              thickness: 1.5,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Sign up with",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                              height: 1.5,
                              thickness: 1.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Image.asset("assets/google.png", width: 24),
                                SizedBox(
                                    width:
                                        8), // Ajustez cet espace selon vos besoins
                                Text(
                                  "Google",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                Image.asset("assets/facebook.png", width: 27),
                                SizedBox(
                                    width:
                                        8), // Ajustez cet espace selon vos besoins
                                Text(
                                  "Facebook",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Signin()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "You already have an account? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "Sign in",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Spacer(),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
