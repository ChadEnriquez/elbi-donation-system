import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageAPI {
  static final storage = FirebaseStorage.instance;

  Future<String> addQRimg(Uint8List imageData, String donationID) async {
    try {
      final storageRef = storage.ref().child('donations').child('$donationID.png');
      await storageRef.putData(imageData);
      String downloadURL = await storageRef.getDownloadURL();
      print(downloadURL);
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return 'Error';
    }
  }
}
