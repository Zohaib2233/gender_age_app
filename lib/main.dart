import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gender_recongnition/gender_age_prediction.dart';
import 'package:gender_recongnition/screens/splash_screen.dart';
import 'package:get_storage/get_storage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.lightBlueAccent
      ),
      title: "Human Gender",
      home: MySplash(),
      // home: GenderAgeClassifier(),
      debugShowCheckedModeBanner: false,
     );
  }
}

