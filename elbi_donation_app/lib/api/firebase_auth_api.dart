import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<void> signUp(String email, String password, String name, List<String> address, String contactno, BuildContext context) async {
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Handle email already in use error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
      } else if (e.code == 'weak-password') {
        // Handle weak password error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Firebase Auth Exception: ${e.code} : ${e.message}'),
          ),
        );
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Firebase Exception: ${e.code} : ${e.message}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<void> signUpOrg(String email, String password, String name, List<String> address, String contactno, String? proofUrl, BuildContext context) async {
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
        'phone': contactno,
        'description': "",
        'status': true,
        'approval': false,
        'proof': proofUrl ?? "",
        'donations': [],
        'donationDrives': [],
      });

      // Show Snackbar if proof is missing
      if (proofUrl == null || proofUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Proof is required for organization registration.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Handle email already in use error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
      } else if (e.code == 'weak-password') {
        // Handle weak password error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${e.message}'),
          ),
        );
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Firebase Exception: ${e.code} : ${e.message}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<String?> signIn(BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        // Show snackbar for incorrect email/password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password.'),
          ),
        );
      } else {
        // Show snackbar for other FirebaseAuthExceptions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${e.message}'),
          ),
        );
      }
      return null;
    } on FirebaseException catch (e) {
      // Show snackbar for FirebaseException
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Firebase Exception: ${e.code} : ${e.message}'),
        ),
      );
      return null;
    } catch (e) {
      // Show snackbar for other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
      return null;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
