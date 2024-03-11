import 'package:black_sigatoka/custom_widgets/custom_appbar.dart';
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
      _imageFile=null;
      print("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Diagnosis'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(top:10),
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
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left:74.0,right:74.0),
            child: ElevatedButton(

              onPressed: () {
                _showImagePicker(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue, // Light blue color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Adjust border radius
                ),
                minimumSize: Size(2, 35), // Adjust width and height
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera_back),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text("Scan"),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left:74.0,right:74.0),
            child: ElevatedButton(

              onPressed: () {
                _showRecommendations(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue, // Light blue color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Adjust border radius
                ),
                minimumSize: Size(2, 35), // Adjust width and height
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 8),
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
                leading: Icon(Icons.camera),
                title: Text('Take a Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Choose from Gallery'),
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

        title: Center(child: Text("Severity Level")),
        content:   Padding(
          padding: const EdgeInsets.only(left:90.0),
          child: Text("High",style: TextStyle(
              color: Colors.green
          ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Recommendations"),
            ),
          ),
        ],
      );
    },
  );
}
