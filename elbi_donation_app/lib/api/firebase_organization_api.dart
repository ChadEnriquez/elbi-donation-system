import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseOrganizationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllOrganizations() {
    return db.collection("organization").snapshots();
  }

  Future<QuerySnapshot> getOrgbyEmail(String? email) async {
    try {
      QuerySnapshot querySnapshot = await db.collection('organization').where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot;
      } else {
        return Future.error('User not found');
      }
    } catch (e) {
      return Future.error(e.toString());
    }
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

  Future<String> editProofimg(String id, String data) async {
    try {
        await db.collection("organization").doc(id).update({"proof": data});
        print("Successfully edited QR URL!");
        return "Successfully edited QR URL!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }
}
