import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // Stream<QuerySnapshot> getAllDonations() {

  // }

  Future<String> addDonation(Map<String, dynamic> donation) async {
    try{
      DocumentReference doc =  await db.collection("donations").add(donation);
      print("Successfully added donation!");
      return doc.id;
    } on FirebaseException catch (e) {
      return "Error => ${e.code}: ${e.message}";
    }
  }

  Future<String> editQRimg(String id, String data) async {
    try {
        await db.collection("donations").doc(id).update({"qrImg": data});
        return "Successfully edited!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }
}
