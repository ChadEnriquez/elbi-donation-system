import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getDonation() {
    return db.collection("donations").snapshots();
  }

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
        print("Successfully edited QR URL!");
        return "Successfully edited QR URL!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Future<String> editDonationPhoto(String id, String data) async {
    try {
        await db.collection("donations").doc(id).update({"photo": data});
        print("Successfully edited photo URL!");
        return "Successfully edited photo URL!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }
}
