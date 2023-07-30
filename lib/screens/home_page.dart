import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gender_recongnition/screens/animation_page.dart';
import 'package:gender_recongnition/screens/auth_screens/login_screen.dart';
import 'package:gender_recongnition/utils/color_resources.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../utils/constants.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  late List _output;
  late List _gender_output;
  final picker = ImagePicker();
  var outputAge;
  bool _loader = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((value)
    {
      setState(() {

      });
    });
  }

  classifyimage(File image)async{
    var output = await Tflite.runModelOnImage(path: image.path, numResults: 8,threshold: 0.5,
    imageMean: 127.5,imageStd: 127.5);


    setState(() {
      _output = output!;

      print(_output);
      _loading = false;
      _loader=false;


    });
    try{
      outputAge = _output[0]['label'];
    } catch(e){
      outputAge = 'Not Detected';
    }
  }

  loadModel() async{
    await Tflite.loadModel(model: 'assets/ageModel/tflite_model_age.tflite',
        labels: 'assets/ageModel/tflite_model_age_label.txt');

  }

  @override
  void dispose() {
    // TODO: implement dispose
    Tflite.close();
    super.dispose();

  }

  pickImage() async{
    var image = await picker.getImage(source: ImageSource.camera);
    if(image == null) return null;

    setState(() {
      _image = File(image.path);
      _loader=true;

    });
    await Future.delayed(const Duration(seconds: 4));
    _loader = false;
    classifyimage(_image);
  }

  pickGallery() async{
    var image = await picker.getImage(source: ImageSource.gallery);
    if(image == null) return null;

    setState(() {
      _image = File(image.path);
      _loader=true;
    });
    await Future.delayed(const Duration(seconds: 4));
    _loader = false;
    classifyimage(_image);
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width/100),

              child: Row(
                children: [
                  const Icon(Icons.logout),

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
      body:
      // ModalProgressHUD(
      //   inAsyncCall: _loader,
      //   child:
    _loader?AnimationPage(animationPath: 'assets/animation_lkdnq12t.json') :Container(
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
                child: _loading ? SizedBox(
                  width: width*0.55,
                  child: Column(
                    children: [
                      Image.asset('assets/image2.png'),
                      SizedBox(height: height*0.1,)
                    ],
                  ),
                ):
                Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: Image.file(_image),
                    ),
                    const SizedBox(height: 20,),
                    _output !=null ? _loader ?const LinearProgressIndicator():Text("Gender: Male  Age: ${outputAge.toUpperCase()}",style: const TextStyle(
                      color: ColorResources.BLACK,fontSize: 20
                    ), ):Container(),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickGallery,
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
                      onTap: pickImage,
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
      // ),
    );
  }
}
