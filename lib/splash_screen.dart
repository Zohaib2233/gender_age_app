
import 'package:flutter/material.dart';
import "package:splashscreen/splashscreen.dart";
import 'constants.dart';

import 'home_page.dart';

class MySplash extends StatefulWidget {
  const MySplash({Key? key}) : super(key: key);

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: const Home(),
      title: Text("Gender Recognition",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: kPrimaryColor
      ),),
      image: Image.asset('assets/image2.png'),
      backgroundColor: Colors.black,
      photoSize: 50,
      loaderColor: kSecondaryColor,
    );
  }
}
