import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/api/firebase_donation_api.dart';
import 'package:elbi_donation_app/api/firebase_storage_api.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:flutter/material.dart';


class DonationsProvider extends ChangeNotifier {
  FirebaseDonationAPI firebaseServiceD = FirebaseDonationAPI();
  FirebaseStorageAPI  firebaseServiceS = FirebaseStorageAPI();
  late Stream<QuerySnapshot> _donations;
  
  Stream<QuerySnapshot> get donations => _donations;

  Future<String> addDonation(Donation donation) async {
    String id = await firebaseServiceD.addDonation(donation.toJson(donation));
    notifyListeners();
    return id;
  }

  void editQRimg(String id, String qrURL) async {
    await firebaseServiceD.editQRimg(id, qrURL);
    notifyListeners();
  }

  Future<String> addQRimg(Uint8List imageData, String donationID) async {
    String url = await firebaseServiceS.addQRimg(imageData, donationID);
    return url;
  }



}