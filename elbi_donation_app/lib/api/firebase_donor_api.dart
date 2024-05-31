import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonorAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<QuerySnapshot> getDonorByEmail(String? email) async {
    try {
      QuerySnapshot querySnapshot = await db.collection('donors').where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot;
      } else {
        return Future.error('User not found');
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<String> addDonation(String userID, List<String> donations) async {
    try {
        await db.collection("donors").doc(userID).update({"donations": donations});
        print("Successfully to donor donation list!");
        return "Success!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Future<String> editDonorDetials(String? id, String type, String newdata) async {
    try {
      switch (type) {
        case 'name':
          await db.collection("donors").doc(id).update({"name": newdata});
        case 'phone':
          await db.collection("donors").doc(id).update({"phone": newdata});
      }
      print("Successfully edited $type!");
      return "Successfully edited $type!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Future<String> editDonorAddress(String? id, List<String> newdata) async {
    try {
      await db.collection("donors").doc(id).update({"address": newdata});
      print("Successfully edited address!");
      return "Successfully edited address!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }
}