import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:test_first/screens/adminHome.dart';
import 'package:test_first/screens/signup.dart';
import 'package:test_first/screens/visitorHome.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

late TextEditingController _emailController;
late TextEditingController _passwordController;
bool _passwordVisible = false;
late GlobalKey<FormState> _formKey;

class _SigninState extends State<Signin> {
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
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
                    labelText: "Email or username",
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
                    EmailValidator(errorText: 'Enter a valid email adress'),
                    RequiredValidator(errorText: 'Email field is required')
                  ]),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
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
                SizedBox(height: 10),
                CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Log in",
                    style: TextStyle(color: Colors.blueGrey.shade100),
                  ),
                  color: Color(0xFF0088cc),
                  borderRadius: BorderRadius.circular(40),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("email = ${_emailController.text}");
                      print("passwrod = ${_passwordController.text}");
                      Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                              builder: ((context) => Visitorhome())),
                          (route) => false);
                    } else {
                      print("error !");
                    }
                  },
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forget password ?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Sign in with",
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
                              width: 8), // Ajustez cet espace selon vos besoins
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
                              width: 8), // Ajustez cet espace selon vos besoins
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
                      CupertinoPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "You don't have an account ? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Sign up",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
