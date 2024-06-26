import 'package:elbi_donation_app/api/firebase_auth_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAuthProvider with ChangeNotifier{
  late Stream<User?> _userStream;
  late FirebaseAuthApi authService;

  UserAuthProvider(){
    authService = FirebaseAuthApi();
    _userStream = authService.fetchUser();
  }

  Stream<User?> get userStream => _userStream;
  User? get user => authService.getUser();

  Future<void> signUp(String email, String password, String name, List<String> address, String contactno, BuildContext context) async {
    await authService.signUp(email, password, name, address, contactno, context);
    notifyListeners();
  }

  Future<void> signUpOrg(String email, String password, String name, List<String> address, String contactno, BuildContext context) async {
    await authService.signUpOrg(email, password, name, address, contactno, context);
    notifyListeners();
  }

  Future<void> signOut() async {
    await authService.signOut();
  }
}