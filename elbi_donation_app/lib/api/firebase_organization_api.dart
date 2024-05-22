import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseOrganizationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllOrganizations() {
    return db.collection("organization").snapshots();
  }


  // Future<String> addFriend(Map<String, dynamic> person) async {
  //   try {
  //     await db.collection("cmsc23-slambookapp").add(person);
  //     return "Successfully added!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }

  // Future<String> deleteFriend(String? id) async {
  //   try {
  //     await db.collection("cmsc23-slambookapp").doc(id).delete();
  //     return "Successfully deleted!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }

  // Future<String> editFriend(String? id, String type, String newdata) async {
  //   try {
  //     switch (type) {
  //       case 'name':
  //         await db.collection("cmsc23-slambookapp").doc(id).update({"name": newdata});
  //       case 'nickname':
  //         await db.collection("cmsc23-slambookapp").doc(id).update({"nickname": newdata});
  //       case 'age':
  //         await db.collection("cmsc23-slambookapp").doc(id).update({"age": newdata});
  //       case 'power':
  //         await db.collection("cmsc23-slambookapp").doc(id).update({"power": newdata});
  //       case 'motto':
  //       await db.collection("cmsc23-slambookapp").doc(id).update({"motto": newdata});
  //     }
  //     return "Successfully edited!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }

  // Future<String> toggleStatus(String? id, bool value) async {
  //   try {
  //     await db.collection("cmsc23-slambookapp").doc(id).update({"inLove": value});
  //     return "Successfully toggled!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }

  // Future<String> editHappiness(String? id, double value) async {
  //   try {
  //     await db.collection("cmsc23-slambookapp").doc(id).update({"happiness": value});
  //     return "Successfully toggled!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }
}
