// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:typed_data';
import 'package:black_sigatoka/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:black_sigatoka/custom_widgets/custom_bottomnavbar.dart';
import 'package:black_sigatoka/screens/recommendations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:developer';
import 'package:black_sigatoka/Data/Models/add_data.dart';
import 'package:uuid/uuid.dart';
import 'package:black_sigatoka/utils/recommendation_utils.dart';

class DiagnosisScreen extends StatefulWidget {
  DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  bool _isLoading = false;
  File? _imageFile;

  // int _currentIndex = 0;
  final PageController _pageController = PageController();

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //     _pageController.animateToPage(
  //       index,
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.easeInOut,
  //     );
  //   });
  //   //implement navigation logic here
  // }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      log("Image picked: $pickedImage");
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    } else {
      _imageFile = null;
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

  void saveIMage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    final image = imageFileToUint8List(imageFile);

    //sending image to firestore and retrieving url
    String imageUrl =
        await StoreData().uploadImageToStorage("${Uuid().v1()}", image);
    print("my download url:$imageUrl");

    //sending url to online model
    final inferenceResults = await StoreData().sendInferenceRequest(imageUrl);

    setState(() {
      _isLoading = false;
    });

    List<dynamic> inferenceResult = json.decode(inferenceResults);
    final severity = inferenceResult[0]['Severity Level Category'];
    final imagecopy = inferenceResult[0]['image_copy'];
    // final severity= getSeverityLevelCategories( inferenceResults);
    print(inferenceResult);
    print(severity);
    print(imagecopy.runtimeType);
    showRecommendations(context, severity, imagecopy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              icon: const Icon(Icons.logout))
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          Column(
            children: [
              const SizedBox(height: 150),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 10),
                height: 150,
                width: 200,
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
                padding: const EdgeInsets.only(left: 74.0, right: 74.0),
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
                padding: const EdgeInsets.only(left: 74.0, right: 74.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_imageFile != null) {
                      saveIMage(_imageFile!);
                    } else {
                      log("image file is empty");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue, 
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0),
                    ),
                    minimumSize: const Size(2, 35), 
                  ),
                  child: _isLoading 
                  ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                  : const Row(
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
          // RecommendationScreen(diseaseSeverity: 'severity'),
        ],
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: _onItemTapped,
      // ),
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
