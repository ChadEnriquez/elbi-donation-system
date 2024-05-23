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

  // void addFriend(Person person) async {
  //   String message = await firebaseService.addFriend(person.toJson(person));
  //   print(message);
  //   notifyListeners();
  // }


  // void deleteFriend(String? id) async{
  //   await firebaseService.deleteFriend(id);
  //   notifyListeners();
  // }

  // void editFriend(String? id, String type, String newdata) async {
  //   await firebaseService.editFriend(id, type, newdata);
  //   notifyListeners();
  // }

  // void toggleStatus(String? id, bool newdata) async {
  //   await firebaseService.toggleStatus(id, newdata);
  //   notifyListeners();
  // }

  // void editHappiness(String? id, double newdata) async {
  //   await firebaseService.editHappiness(id, newdata);
  //   notifyListeners();
  // }
}