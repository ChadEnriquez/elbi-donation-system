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
}