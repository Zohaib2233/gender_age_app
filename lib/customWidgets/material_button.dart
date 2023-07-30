import 'package:flutter/material.dart';
import 'package:gender_recongnition/utils/utils.dart';


class Button extends StatelessWidget {
  const Button({
    super.key,
    @required this.buttonText,
    @required this.onPressed,
  });

  final String? buttonText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Material(
        elevation: 5,
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(30),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: height(context)*0.07,
          child: Text(
              buttonText!,style: TextStyle(color: Colors.white),
          ),
        ),
      ),);
  }
}