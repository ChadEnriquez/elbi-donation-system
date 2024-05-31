import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/api/firebase_organization_api.dart';
import 'package:elbi_donation_app/api/firebase_storage_api.dart';
import 'package:flutter/material.dart';


class OrganizationProvider extends ChangeNotifier {
  FirebaseOrganizationAPI firebaseService = FirebaseOrganizationAPI();
  FirebaseStorageAPI firebaseServiceStorage = FirebaseStorageAPI();
  late Stream<QuerySnapshot> _organizations;
  
  OrganizationProvider() {
    fetchOrganizations();
  }

  Stream<QuerySnapshot> get organizations => _organizations;

  void fetchOrganizations() {
    _organizations = firebaseService.getAllOrganizations();
    notifyListeners();
  }

  void addDonation(String orgID, List<String> donations) async {
    await firebaseService.addDonation(orgID, donations);
    notifyListeners();
  }

  Future<String> addProofPhoto(XFile imageData, String orgID) async {
    String url = await firebaseServiceStorage.addProofimg(imageData, orgID);
    return url;
  }

  void editProofimg(String id, String qrURL) async {
    await firebaseService.editProofimg(id, qrURL);
    notifyListeners();
  }
}