import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_recongnition/customWidgets/material_button.dart';
import 'package:gender_recongnition/customWidgets/text_field.dart';
import 'package:gender_recongnition/customWidgets/textfield/custom_password_textfield.dart';

import 'package:gender_recongnition/screens/auth_screens/login_screen.dart';
import 'package:gender_recongnition/screens/home_page.dart';
import 'package:gender_recongnition/utils/utils.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

  bool showProgress = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address.';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.lightBlueAccent,
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showProgress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: height(context) * 0.15,
                  ),
                  Container(
                    height: height(context) * 0.4,
                    child: Image.asset('assets/newlogo.png'),
                  ),

                  InputField(
                      hintText: "Enter Your Email",
                      controller: _emailController,
                      isValidate: _validateEmail,
                      isPassword: false),
                  SizedBox(
                    height: 8,
                  ),
                  CustomPasswordTextField(
                    hintTxt: "Enter Password",
                    isValidate: _validatePassword,

                    controller: _passwordController,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomPasswordTextField(
                    hintTxt: "Enter Confirm Password",
                    controller: _confirmPasswordController,
                    isValidate: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: height(context) * 0.03,
                  ),
                  Button(
                      buttonText: "Register",
                      onPressed: () async {

                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            showProgress=true;
                          });
                          final String email = _emailController.text.trim();
                          final String password = _passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            return;
                          }

                          try {
                            UserCredential userCredential =
                            await _auth.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            print('Registered user: ${userCredential.user}');
                            bool isRegistrationSuccessful = true;

                            if (isRegistrationSuccessful) {
                              setState(() {
                                showProgress=false;
                              });

                              _showSnackBar(context, 'User registered successfully!');
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                      (route) => false);

                            } else {
                            }

                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              showProgress=false;
                            });

                            if (e.code == 'weak-password') {
                              _showSnackBar(context, "The password provided is too weak.");
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'The account already exists for that email.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                duration: Duration(seconds: 1),
                              ));
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                      }),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have Account ?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text("Login"))
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
