import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/api/firebase_organization_api.dart';
import 'package:elbi_donation_app/api/firebase_storage_api.dart';
import 'package:elbi_donation_app/model/organization.dart';
import 'package:flutter/material.dart';


class OrganizationProvider extends ChangeNotifier {
  FirebaseOrganizationAPI firebaseService = FirebaseOrganizationAPI();
  FirebaseStorageAPI firebaseServiceStorage = FirebaseStorageAPI();
  late Stream<QuerySnapshot> _organizations;
  late List<dynamic> _currentOrg;
  
  OrganizationProvider() {
    fetchOrganizations();
  }

  Stream<QuerySnapshot> get organizations => _organizations;

  List<dynamic> get currentOrg => _currentOrg;


  //Will return the donor ID and details of donor in a List
  Future<void> getOrg(String? email) async {
      QuerySnapshot donorSnapshot = await firebaseService.getOrgbyEmail(email);
      _currentOrg = [ donorSnapshot.docs.first.id,Organization.fromJson(donorSnapshot.docs.first.data() as Map<String, dynamic>)];
      print(_currentOrg);
  }

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