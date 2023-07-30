
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_recongnition/screens/auth_screens/login_screen.dart';
import 'package:gender_recongnition/utils/color_resources.dart';
import 'package:gender_recongnition/utils/constants.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gender_recongnition/home_screen.dart';

import 'package:cross_file/cross_file.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;

  late File _image;
  late List<dynamic> _genderResult;
  late List<dynamic> _ageResult;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadModels();

  }



  Future<void> _loadModels() async {

    await Tflite.loadModel(
      model: 'assets/genderModel/model_unquant.tflite',
      labels: 'assets/genderModel/labels.txt',
    );

    await Tflite.loadModel(
      model: 'assets/ageModel/model_unquant.tflite',
      labels: 'assets/ageModel/labels.txt',
    );


  }

  Future<void> _getImageFromCamera() async {
    final image = await ImagePicker().getImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _predict();
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _predict();
      });
    }
  }

  Future<void> _predict() async {
    if (_image == null) return;

    // Gender prediction
    final genderResult = await Tflite.runModelOnImage(
      path: _image.path,
      numResults: 2,
    );
    print(genderResult);
    setState(() {
      _loading = false;
      _genderResult = genderResult!;
    });


    // Age prediction
    final ageResult = await Tflite.runModelOnImage(
      path: _image.path,
      numResults: 4,
    );
    setState(() {
      _loading = false;
      _ageResult = ageResult!;
    });
    print(_ageResult);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  // late File _image;
  // late List<dynamic> _predictionResult;
  // // late List _output;
  // final picker = ImagePicker();
  //
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //
  //   loadModels();
  //   setState(() {
  //
  //   });
  //   super.initState();
  //   // loadModel().then((value)
  //   // {
  //   //   setState(() {
  //   //
  //   //   });
  //   // });
  // }
  //
  // void loadModels() async {
  //   await Tflite.loadModel(
  //     model: 'assets/genderModel/model_unquant.tflite',
  //     labels: 'assets/genderModel/labels.txt',
  //   );
  //   await Tflite.loadModel(
  //     model: 'assets/ageModel/model_unquant.tflite',
  //     labels: 'assets/ageModel/labels.txt',
  //   );
  // }
  //
  // //
  // // classifyimage(File image)async{
  // //   var output = await Tflite.runModelOnImage(path: image.path, numResults: 2,threshold: 0.5,
  // //       imageMean: 127.5,imageStd: 127.5);
  // //   print(_image);
  // //   setState(() {
  // //     _output = output!;
  // //     print(_output);
  // //     _loading = false;
  // //
  // //   });
  // // }
  //
  // // loadModel() async{
  // //   await Tflite.loadModel(model: 'assets/genderModel/model_unquant.tflite',
  // //       labels: 'assets/genderModel/labels.txt');
  // // }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   Tflite.close();
  //   super.dispose();
  //
  // }
  //
  //
  // Future<List<dynamic>?> predictGenderAndAge(File imageFile) async {
  //   final recognitions = await Tflite.runModelOnImage(
  //     path: imageFile.path,
  //     imageMean: 0.0,
  //     imageStd: 255.0,
  //     numResults: 6,
  //     threshold: 0.1,
  //     asynch: true,
  //   );
  //   setState(() {
  //     _loading = false;
  //     print(recognitions);
  //   });
  //   return recognitions;
  // }
  //
  // Future<void> _getImageAndPredict() async {
  //   final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     setState(() {
  //       _image = File(pickedImage.path);
  //       // _predictionResult = null;
  //     });
  //
  //     final predictions = await predictGenderAndAge(_image);
  //     setState(() {
  //       _predictionResult = predictions!;
  //       print(_predictionResult[0]);
  //     });
  //   }
  // }
  //
  // Future<void> _getImageFromCamera() async {
  //   final pickedImage = await ImagePicker().getImage(source: ImageSource.camera);
  //   if (pickedImage != null) {
  //     setState(() {
  //       _image = File(pickedImage.path);
  //       // _predictionResult = null;
  //     });
  //
  //     final predictions = await predictGenderAndAge(_image);
  //     setState(() {
  //       _predictionResult = predictions!;
  //       print(predictions);
  //     });
  //   }
  // }
  //
  // // pickImage() async{
  // //   var image = await picker.getImage(source: ImageSource.camera);
  // //   if(image == null) return null;
  // //
  // //   setState(() {
  // //     _image = File(image.path);
  // //
  // //   });
  // //   classifyimage(_image);
  // // }
  // //
  // // pickGallery() async{
  // //   var image = await picker.getImage(source: ImageSource.gallery);
  // //   if(image == null) return null;
  // //
  // //   setState(() {
  // //     _image = File(image.path);
  // //
  // //   });
  // //   classifyimage(_image);
  // // }



  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width/100),
            child: Row(
              children: [
                Icon(Icons.logout),
                TextButton(
                  onPressed: () {
                    GetStorage().remove("isLoggedIn");
                    signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                  },
                  child: const Text("Log Out",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
      // backgroundColor: const Color(0xFF101010),
      backgroundColor: ColorResources.WHITE,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 35,),
            const Text("Gender and Age Classification",style: TextStyle(
              color: kPrimaryColor,
              fontSize: 15,
            ),),
            const SizedBox(height: 6,),
            const Text("Detect Gender and Age",style: TextStyle(
                color: kSecondaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 28
            ),),
            const SizedBox(height: 40,),
            Center(
              child: _loading ? Container(
                width: 300,
                child: Column(
                  children: [
                    Image.asset('assets/image2.png'),
                    const SizedBox(height: 50,)
                  ],
                ),
              ):
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Image.file(_image),
                      height: 250,
                    ),
                    const SizedBox(height: 20,),
                    Text("Gender: MALE Age ${_genderResult[0]['label']}",style: const TextStyle(
                        color: ColorResources.BLACK,fontSize: 20
                    ), ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _getImageFromGallery,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: MediaQuery.of(context).size.width-230,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 17),
                        decoration: BoxDecoration(color: Colors.lightBlueAccent,borderRadius: BorderRadius.circular(10)),
                        child: const Text("Open Gallery",style: TextStyle(
                          color: Colors.white,
                        ),),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  GestureDetector(
                    onTap: _getImageFromCamera,
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5,
                      child: Container(

                        width: MediaQuery.of(context).size.width-230,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 17),
                        decoration: BoxDecoration(color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(10),),
                        child: const Text("Open Camera",style: TextStyle(
                          color: Colors.white,
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
