import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/api/firebase_organization_api.dart';
import 'package:flutter/material.dart';


class OrganizationProvider extends ChangeNotifier {
  FirebaseOrganizationAPI firebaseService = FirebaseOrganizationAPI();
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
}