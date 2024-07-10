import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(
      String filename, Uint8List imageFile) async {
    Reference ref = _storage.ref().child("sigatoka_images/$filename");
    UploadTask uploadTask = ref.putData(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadurl = await taskSnapshot.ref.getDownloadURL();

    return downloadurl;
  }

  Future<String> saveData(
      {required String userId,
      required String diagnosis,
      required Uint8List file}) async {
    String resp = "Some error occured";
    try {
      String imageUrl = await uploadImageToStorage("sigatokaImage", file);
      await _firestore.collection("User Images").add(
          {'email': userId, 'imageLink': imageUrl, 'Diagnosis': diagnosis});
      resp = "success";
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  // Function to send inference request
  Future<dynamic> sendInferenceRequest(String imageUrl) async {
    const endpointUrl =
        "https://yolo-endpoint.westus.inference.ml.azure.com/score";
    const apiKey = "MJaWzVibh7DrB6pIkrjXd1vkPFscEz21"; // Replace with your API key

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final requestData = {
      "image_urls": [imageUrl],
    };

    try {
      final response = await http.post(Uri.parse(endpointUrl),
          headers: headers, body: jsonEncode(requestData));
      if (response.statusCode == 200) {
        final parsedData = jsonDecode(response.body);
        log("my type ${parsedData.runtimeType}");
        return parsedData;
      } else {
        log('Error sending inference request: ${response.statusCode}');
      }
    } catch (error) {
      log('Error sending inference request or parsing response: $error');
    }
  }
}
