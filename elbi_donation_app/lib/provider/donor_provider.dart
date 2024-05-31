
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/api/firebase_donor_api.dart';
import 'package:elbi_donation_app/model/donor.dart';
import 'package:flutter/foundation.dart';

class DonorProvider with ChangeNotifier {
  late FirebaseDonorAPI donorService;
  late List<dynamic> _donor;

  DonorProvider(){
    donorService = FirebaseDonorAPI();
  }

  List<dynamic> get donor => _donor;

  //Will return the donor ID and details of donor in a List
  void getDonor(String? email) async {
      QuerySnapshot donorSnapshot = await donorService.getDonorByEmail(email);
      _donor = [ donorSnapshot.docs.first.id ,Donor.fromJson(donorSnapshot.docs.first.data() as Map<String, dynamic>)];
      print(_donor);
  }

  void addDonation(String donorID, List<String> donations) async {
    await donorService.addDonation(donorID, donations);
    notifyListeners();
  }

  void editDonorDetails(String? id, String type, String newdata) async {
    await donorService.editDonorDetials(id, type, newdata);
    notifyListeners();
  }

  void editDonorAddress(String? id, List<String> newdata) async {
    await donorService.editDonorAddress(id, newdata);
    notifyListeners();
  }
}