import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthApi {
  late FirebaseAuth auth;
  FirebaseAuthApi(){
    auth = FirebaseAuth.instance;
  }

  Stream<User?> fetchUser(){
    return auth.authStateChanges();
  }

  User? getUser() {
    return auth.currentUser;
  }

  Future<void> signUp(String email, String password, String name, String address, String contactno) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('donors')
          .doc(credential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'address': address,
        'contactno': contactno,
        'donations': [],
      });
    } on FirebaseException catch (e) {
      print("Firebase Exception: ${e.code} : ${e.message}");
    } catch (e) {
      print("Error 001: $e");
    }
  }

    Future<void> signUpOrg(String email, String password, String name, String address, String contactno, String description, bool status) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await FirebaseFirestore.instance
          .collection('organization')
          .doc(credential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'address': address,
        'contactno': contactno,
        'description': description,
        'status': status,
      });
    } on FirebaseException catch (e) {
      print("Firebase Exception: ${e.code} : ${e.message}");
    } catch (e) {
      print("Error 001: $e");
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseException catch(e) {
      return "Error: ${e.code} : ${e.message}";
    } catch (e) {
      return "Error: $e";
    }
  }
    Future<void> signOut() async {
      await auth.signOut();
    }

    
}