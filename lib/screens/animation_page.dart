import 'package:flutter/material.dart';
import 'package:gender_recongnition/screens/home_page.dart';
import 'package:gender_recongnition/utils/utils.dart';
import 'package:lottie/lottie.dart';

class AnimationPage extends StatelessWidget {
  final String animationPath;

  const AnimationPage({required this.animationPath});


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Lottie.asset(
                animationPath,
                repeat: true,
                reverse: false,
                animate: true,
                width: width(context)*0.8,
                height: height(context)*0.8,

              ),
              Text("Please Wait.....",
              style: TextStyle(
                color: Colors.blue
              ),),
            ],
          ),
        ),
      );
  }
}
