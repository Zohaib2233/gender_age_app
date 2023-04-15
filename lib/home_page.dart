
import 'dart:io';

import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_file/cross_file.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();


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
    var output = await Tflite.runModelOnImage(path: image.path, numResults: 2,threshold: 0.5,
    imageMean: 127.5,imageStd: 127.5);
    print(_image);
    setState(() {
      _output = output!;
      print(_output);
      _loading = false;
      
    });
  }
  
  loadModel() async{
    await Tflite.loadModel(model: 'assets/model_unquant.tflite',labels: 'assets/labels.txt');
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

    });
    classifyimage(_image);
  }

  pickGallery() async{
    var image = await picker.getImage(source: ImageSource.gallery);
    if(image == null) return null;

    setState(() {
      _image = File(image.path);

    });
    classifyimage(_image);
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 75,),
            const Text("Gender Classification through CNN",style: TextStyle(
              color: kPrimaryColor,
              fontSize: 15,
            ),),
            const SizedBox(height: 6,),
            const Text("Detect Male and Female",style: TextStyle(
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
                    const SizedBox(height: 50,),
                    _output !=null ? Text("${_output[0]['label'].toUpperCase()}",style: const TextStyle(
                      color: Colors.white,fontSize: 20
                    ), ):Container(),
                    const SizedBox(
                      height: 10,
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
                    onTap: pickGallery,
                    child: Container(
                      width: MediaQuery.of(context).size.width-230,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 17),
                      decoration: BoxDecoration(color: kSecondaryColor,borderRadius: BorderRadius.circular(10)),
                      child: const Text("Open Gallery",style: TextStyle(
                        color: Colors.white,
                      ),),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width-230,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 17),
                      decoration: BoxDecoration(color: kSecondaryColor,borderRadius: BorderRadius.circular(10)),
                      child: const Text("Open Camera",style: TextStyle(
                        color: Colors.white,
                      ),),
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
