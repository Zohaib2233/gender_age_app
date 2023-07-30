
import 'package:flutter/material.dart';
import 'package:gender_recongnition/home_screen.dart';
import 'package:gender_recongnition/screens/auth_screens/login_screen.dart';
import 'package:gender_recongnition/screens/home_page.dart';
import 'package:gender_recongnition/utils/constants.dart';
import 'package:gender_recongnition/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import "package:splashscreen/splashscreen.dart";

class MySplash extends StatefulWidget {
  const MySplash({Key? key}) : super(key: key);

  @override
  State<MySplash> createState() => _MySplashState();
}
pushAndRemoveUntil(BuildContext context, Widget destination, bool predict) {
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => destination), (Route<dynamic> route) => predict);
}

class _MySplashState extends State<MySplash> {

  @override
  void initState() {
    bool? isLoggedIn = GetStorage().read("isLoggedIn");
    if (isLoggedIn ?? false) {
      Future.delayed(const Duration(seconds: 3),(){
        pushAndRemoveUntil(context, const Home(), false);
      });

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: LoginScreen(),

      image: Image.asset('assets/newlogo.png'),

      backgroundColor: Colors.white,
      photoSize: height(context)*0.3,
      loaderColor: kSecondaryColor,
    );
  }
}
