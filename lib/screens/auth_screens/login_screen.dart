import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_recongnition/customWidgets/material_button.dart';
import 'package:gender_recongnition/customWidgets/text_field.dart';
import 'package:gender_recongnition/customWidgets/textfield/custom_password_textfield.dart';
import 'package:gender_recongnition/screens/home_page.dart';
import 'package:gender_recongnition/home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:gender_recongnition/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toast/toast.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool showProgress =false;

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

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
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
                    height: height(context) * 0.03,
                  ),
                  Button(
                      buttonText: "Login",
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
                            await _auth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            print('Logged in user: ${userCredential.user}');
                            GetStorage().write("isLoggedIn", true);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: Colors.lightBlueAccent,
                              content: Text(
                                'Successfully LoggedIn!',
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(seconds: 2),
                            ));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
                            setState(() {
                              showProgress = false;
                            });
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              showProgress = false;
                            });
                            if (e.code == 'user-not-found') {
                              Toast.show("No user found for that email.",
                                  duration: Toast.lengthLong);
                              print('No user found for that email.');
                            } else if (e.code == 'wrong-password') {
                              Toast.show("Wrong password provided for that user.",
                                  duration: Toast.lengthLong);
                              print('Wrong password provided for that user.');
                            }
                          } catch (e) {
                            setState(() {
                              showProgress = false;
                            });
                            Toast.show(e.toString(), duration: Toast.lengthLong);
                            print(e);
                          }
                        }}),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't Have Account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationScreen()));
                          },
                          child: Text("Register"))
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
