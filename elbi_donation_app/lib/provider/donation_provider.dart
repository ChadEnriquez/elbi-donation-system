
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/api/firebase_donation_api.dart';
import 'package:elbi_donation_app/api/firebase_storage_api.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:flutter/material.dart';


class DonationsProvider extends ChangeNotifier {
  FirebaseDonationAPI firebaseServiceD = FirebaseDonationAPI();
  FirebaseStorageAPI  firebaseServiceS = FirebaseStorageAPI();
  late Stream<QuerySnapshot> _donations;

  DonationsProvider(){
    fetchDonations();
  }
  
  Stream<QuerySnapshot> get donations => _donations;

  void fetchDonations() {
    _donations = firebaseServiceD.getDonation();
    notifyListeners();
  }
 
  Future<String> addDonation(Donation donation) async {
    String id = await firebaseServiceD.addDonation(donation.toJson(donation));
    notifyListeners();
    return id;
  }

  Future<String> addQRimg(XFile imageData, String donationID) async {
    String url = await firebaseServiceS.addQRimg(imageData, donationID);
    return url;
  }

  void editQRimg(String id, String qrURL) async {
    await firebaseServiceD.editQRimg(id, qrURL);
    notifyListeners();
  }

  Future<String> addDonationPhoto(XFile imageData, String donationID) async {
    String url = await firebaseServiceS.addDonationPhoto(imageData, donationID);
    return url;
  }

  void editDonationPhoto(String id, String qrURL) async {
    await firebaseServiceD.editDonationPhoto(id, qrURL);
    notifyListeners();
  }
}