import 'package:black_sigatoka/custom_widgets/custom_appbar.dart';
import 'package:black_sigatoka/screens/recommendations_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Diagnosis extends StatefulWidget {
  const Diagnosis({super.key});

  @override
  State<Diagnosis> createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      print("Image picked: $pickedImage");
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    } else {
      _imageFile = null;
      print("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Diagnosis'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
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
                backgroundColor: Colors.lightBlue, // Light blue color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12.0), // Adjust border radius
                ),
                minimumSize: const Size(2, 35), // Adjust width and height
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
                _showRecommendations(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue, // Light blue color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12.0), // Adjust border radius
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
        content: const Padding(
          padding: EdgeInsets.only(left: 90.0),
          child: Text(
            "High",
            style: TextStyle(color: Colors.green),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RecommendationScreen(
                              diseaseSeverity: '',
                            )));
              },
              child: const Text("Recommendations"),
            ),
          ),
        ],
      );
    },
  );
}
