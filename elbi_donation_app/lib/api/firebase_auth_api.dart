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

  Future<void> signUpOrg(String email, String password, String name, List<String> address, String contactno, BuildContext context) async {
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
        'approval' : false,
        'proof' : "",
        'donations' : [],
        'donationDrives' : [],
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