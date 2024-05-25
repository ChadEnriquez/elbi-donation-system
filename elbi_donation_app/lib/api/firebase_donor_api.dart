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
}