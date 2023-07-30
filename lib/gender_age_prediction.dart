// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;
//
// class GenderAgeClassifier extends StatefulWidget {
//   @override
//   _GenderAgeClassifierState createState() => _GenderAgeClassifierState();
// }
//
// class _GenderAgeClassifierState extends State<GenderAgeClassifier> {
//   Interpreter? genderInterpreter;
//   Interpreter? ageInterpreter;
//   File? imageFile;
//   List<String> genders = ['Male', 'Female'];
//   List<String> ageClasses = ['Child', 'Teenager', 'Adult', 'Elderly'];
//   String? genderResult;
//   String? ageResult;
//
//   @override
//   void initState() {
//     super.initState();
//     loadModels();
//   }
//
//   Future<void> loadModels() async {
//     try {
//       genderInterpreter = await Interpreter.fromAsset('assets/genderModel/model_unquant.tflite');
//       ageInterpreter = await Interpreter.fromAsset('assets/ageModel/model_unquant.tflite');
//     } catch (e) {
//       print('Failed to load models: $e');
//     }
//   }
//
//   Future<void> classifyImage(File file) async {
//     if (file == null) return;
//
//     try {
//       var input = preprocessImage(file);
//
//       var genderOutput = List.filled(1 * 2, 0.0).reshape([1, 2]);
//       var ageOutput = List.filled(1 * 4, 0.0).reshape([1, 4]);
//
//       genderInterpreter?.run(input, genderOutput);
//       ageInterpreter?.run(input, ageOutput);
//
//       var genderIndex = genderOutput[0].indexOf(genderOutput[0].reduce((a, b) => a > b ? a : b));
//       genderResult = genders[genderIndex];
//
//       var ageIndex = ageOutput[0].indexOf(ageOutput[0].reduce((a, b) => a > b ? a : b));
//       ageResult = ageClasses[ageIndex];
//
//       setState(() {});
//     } catch (e) {
//       print('Failed to classify image: $e');
//     }
//   }
//
//   Uint8List preprocessImage(File file) {
//     // // Load the image using the image package
//     img.Image? image = img.decodeImage(file.readAsBytesSync());
//     //
//     // // Resize the image to the desired input dimensions
//     img.Image resizedImage = img.copyResize(image!, width: 224, height: 224);
//     //
//     // // Normalize pixel values to the range of 0-1
//     var inputImage = resizedImage.getBytes();
//     // for (var i = 0; i < inputImage.length; i += 3) {
//     //   inputImage[i] = ((inputImage[i] / 127.5) - 1.0) as int;
//     //   inputImage[i + 1] = ((inputImage[i + 1] / 127.5) - 1.0) as int;
//     //   inputImage[i + 2] = ((inputImage[i + 2] / 127.5) - 1.0) as int;
//     // }
//     //
//     // // Convert the image data to Uint8List
//     Uint8List inputImageData = Uint8List.fromList(inputImage);
//     //
//     return inputImageData;
//
//
//   }
//
//   // Uint8List preprocessImage(File file) {
//   //   // Implement your image preprocessing logic here
//   //   // Convert the image to the desired input format for the models
//   // }
//
//   Future<void> selectImage(ImageSource source) async {
//     var imagePicker = ImagePicker();
//     var pickedImage = await imagePicker.getImage(source: source);
//
//     if (pickedImage != null) {
//       setState(() {
//         imageFile = File(pickedImage.path);
//       });
//
//       classifyImage(imageFile!);
//     }
//   }
//
//   @override
//   void dispose() {
//     genderInterpreter?.close();
//     ageInterpreter?.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gender and Age Classification'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               selectImage(ImageSource.camera);
//             },
//             child: Text('Take a Photo'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               selectImage(ImageSource.gallery);
//             },
//             child: Text('Choose from Gallery'),
//           ),
//           if (imageFile != null)
//             Image.file(
//               imageFile!,
//               height: 200,
//               width: 200,
//             ),
//           if (genderResult != null && ageResult != null)
//             Column(
//               children: [
//                 Text('Gender: $genderResult',style: TextStyle(color: Colors.black),),
//                 Text('Age: $ageResult'),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }
