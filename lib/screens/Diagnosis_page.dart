// ignore_for_file: file_names

import 'dart:typed_data';
import 'package:black_sigatoka/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:black_sigatoka/screens/recommendations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:developer';
import 'package:black_sigatoka/Data/Models/add_data.dart';


class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      log("Image picked: $pickedImage");
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    } else {
      _imageFile=null;
      log("No image selected");
    }
  }

  Uint8List imageFileToUint8List(File imagefile) {
    // Read the file as bytes
    List<int> bytes = imagefile.readAsBytesSync();

    // Convert bytes to Uint8List
    Uint8List uint8Listfile = Uint8List.fromList(bytes);

    return uint8Listfile;
  }

  void saveIMage(File imageFile) async{
    final image =imageFileToUint8List(imageFile);

    //sending image to firestore and retrieving url
    String imageUrl = await StoreData().uploadImageToStorage("image ", image);
    print("my download url:$imageUrl");

    //sending url to online model
   // final inferenceResults = await StoreData().sendInferenceRequest(imageUrl);
    //print("my results: $inferenceResults");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      backgroundColor: Colors.white,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 30),
        child: Row(
          children: [
            Center(
              child: Image.asset(
                'assets/images/Logo.png',
                height: 30,
                width: 30,
              ),
            ),
            const SizedBox(width: 5),
            Center(
              child: Text(
                'Diagnosis'.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(const SignOutRequired());
            },
            icon: const Icon(Icons.logout)
          )
      ],
    ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(top:10),
            height: 150,
            width:200,
            color: Colors.grey[300], // Placeholder background color
            child: _imageFile != null
                ? Image.file(
              _imageFile!,
              height: 150,
              fit: BoxFit.cover,
            )
                : Icon(
              Icons.image,
              size: 50,
              color: Colors.grey[400], // Image icon color
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left:74.0,right:74.0),
            child: ElevatedButton(

              onPressed: () {
                _showImagePicker(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 127, 181, 230), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera_back),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text("Scan"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left:74.0,right:74.0),
            child: ElevatedButton(

              onPressed: () {
                if(_imageFile != null){
                  saveIMage(_imageFile!);
                }else{
                  print("image file is empty");
                }


                //_showRecommendations(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue, // Light blue color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Adjust border radius
                ),
                minimumSize: const Size(2, 35), // Adjust width and height
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text("Diagnose"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
void _showRecommendations(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(

        title: const Center(child: Text("Severity Level")),
        content:   const Padding(
          padding: EdgeInsets.only(left:90.0),
          child: Text("High",style: TextStyle(
              color: Colors.green
          ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const RecommendationScreen(diseaseSeverity: 'High',)));
                  },
              child: const Text("Recommendations"),
            ),
          ),
        ],
      );
    },
  );
}
