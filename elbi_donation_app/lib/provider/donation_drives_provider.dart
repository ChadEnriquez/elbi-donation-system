import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/api/firebase_donation_api.dart';
import 'package:elbi_donation_app/api/firebase_storage_api.dart';
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
}