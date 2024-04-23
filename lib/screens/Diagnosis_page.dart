// ignore_for_file: file_names

import 'dart:convert';
import 'dart:typed_data';
import 'package:black_sigatoka/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:black_sigatoka/screens/recommendations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:developer';
import 'package:black_sigatoka/Data/Models/add_data.dart';
import 'package:uuid/uuid.dart';



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



  String getSeverityLevelCategories(String jsonString) {
    // Parse the JSON string into a Dart object
    List<dynamic> inferenceResults = json.decode(jsonString);

    // Check if inferenceResults is a list and not null
    if (inferenceResults != null && inferenceResults is List) {
      // Initialize an empty string to store the concatenated severity level categories
      String severityLevelCategories = '';

      // Iterate through each result and concatenate the severity level category to the string
      for (var result in inferenceResults) {
        // Ensure "Severity Level Category" is not null and is a string
        if (result["Severity Level Category"] != null &&
            result["Severity Level Category"] is String) {
          // Concatenate the severity level category with a comma and space
          severityLevelCategories +=
          '${result["Severity Level Category"]}, ';
        }
      }

      // Remove the trailing comma and space
      severityLevelCategories = severityLevelCategories.isNotEmpty
          ? severityLevelCategories.substring(0, severityLevelCategories.length - 2)
          : '';

      // Return the concatenated severity level categories string
      return severityLevelCategories;
    } else {
      // Return an empty string if inferenceResults is null or not a list
      return '';
    }
    
  }





  void saveIMage(File imageFile) async{
    final image =imageFileToUint8List(imageFile);

    //sending image to firestore and retrieving url
    String imageUrl = await StoreData().uploadImageToStorage("${Uuid().v1()}", image);
    print("my download url:$imageUrl");

    //sending url to online model
   final inferenceResults = await StoreData().sendInferenceRequest(imageUrl);


      final severity= getSeverityLevelCategories( inferenceResults);
      print(severity);
      _showRecommendations(context,severity);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      backgroundColor: Colors.white,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
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
void _showRecommendations(BuildContext context,String severity) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(

        title: const Center(child: Text("Severity Level")),
        content:    Padding(
          padding: EdgeInsets.only(left:90.0),
          child: Text(severity,style: TextStyle(
              color: Colors.green
          ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>  RecommendationScreen(diseaseSeverity: severity,)));
                  },
              child: const Text("Recommendations"),
            ),
          ),
        ],
      );
    },
  );
}
