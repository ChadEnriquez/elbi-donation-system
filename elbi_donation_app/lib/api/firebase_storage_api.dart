import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageAPI {
  static final storage = FirebaseStorage.instance;

  Future<String> addQRimg(XFile imageData, String donationID) async {
    try {
      final file = File(imageData.path);
      final storageRef = storage.ref().child('donations').child('${donationID}_QR.png');
      await storageRef.putFile(file);
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return 'Error';
    }
  }

  Future<String> addDonationPhoto(XFile imageData, String donationID) async {
    try {
      final file = File(imageData.path);
      final storageRef = storage.ref().child('donations').child('${donationID}_Photo.png');
      await storageRef.putFile(file);
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return 'Error';
    }
  }

  
}
