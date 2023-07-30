import 'package:flutter/material.dart';

double height(context){
  double height = MediaQuery.of(context).size.height;
  return height;
}

double width(context){
  double width = MediaQuery.of(context).size.width;
  return width;
}

TextStyle ktextStyle = const TextStyle(color: Colors.white,fontSize: 16);


