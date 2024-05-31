
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/api/firebase_donation_api.dart';
import 'package:elbi_donation_app/api/firebase_storage_api.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:flutter/material.dart';


class DonationsProvider extends ChangeNotifier {
  FirebaseDonationAPI firebaseServiceDonation = FirebaseDonationAPI();
  FirebaseStorageAPI  firebaseServiceStorage = FirebaseStorageAPI();
  late Stream<QuerySnapshot> _donations;

  DonationsProvider(){
    fetchDonations();
  }
  
  Stream<QuerySnapshot> get donations => _donations;

  void fetchDonations() {
    _donations = firebaseServiceDonation.getDonation();
    notifyListeners();
  }
 
  Future<String> addDonation(Donation donation) async {
    String id = await firebaseServiceDonation.addDonation(donation.toJson(donation));
    notifyListeners();
    return id;
  }

  Future<String> addQRimg(XFile imageData, String donationID) async {
    String url = await firebaseServiceStorage.addQRimg(imageData, donationID);
    return url;
  }

  void editQRimg(String id, String qrURL) async {
    await firebaseServiceDonation.editQRimg(id, qrURL);
    notifyListeners();
  }

  Future<String> addDonationPhoto(XFile imageData, String donationID) async {
    String url = await firebaseServiceStorage.addDonationPhoto(imageData, donationID);
    return url;
  }

  void editDonationPhoto(String id, String qrURL) async {
    await firebaseServiceDonation.editDonationPhoto(id, qrURL);
    notifyListeners();
  }

  void editStatus(String id, String status) async {
    await firebaseServiceDonation.editStatus(id, status);
    notifyListeners();
  }
}