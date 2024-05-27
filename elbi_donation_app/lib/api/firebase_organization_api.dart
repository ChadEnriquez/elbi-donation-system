import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseOrganizationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllOrganizations() {
    return db.collection("organization").snapshots();
  }

  Future<String> addDonation(String orgID, List<String> donations) async {
    try {
        await db.collection("organization").doc(orgID).update({"donations": donations});
        print("Successfully addedd to organization donation list!");
        return "Success!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }
}
