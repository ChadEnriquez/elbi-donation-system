import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/admin/admin_home_page.dart';
import 'package:elbi_donation_app/donor/donor_pages/donor_home_page.dart';
import 'package:elbi_donation_app/organization/org_home_page.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool _showSignInErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(230, 212, 184, 1), Color.fromRGBO(199, 177, 152, 1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    if (snapshot.data != null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return _buildSignInForm();
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/Logo.png',
                width: 100, 
                height: 100, 
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  "Title po huhu?",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Add a slight curve
                    ),
                    labelText: "Email",
                    hintText: "juandelacruz09@gmail.com",
                    prefixIcon: Icon(Icons.email), // Add email icon
                  ),
                  onSaved: (value) => _email = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Add a slight curve
                    ),
                    labelText: "Password",
                    hintText: "********",
                    prefixIcon: Icon(Icons.lock), // Add lock icon
                  ),
                  obscureText: true,
                  onSaved: (value) => _password = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(199, 177, 152, 1)), // Set button color to beige
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                      ),
                    ),
                  ),
                  child: const Text("Sign In", style: TextStyle(color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No account yet?",
                      style: TextStyle(color: Colors.white), 
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(199, 177, 152, 1)), // Set button color to beige
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
                          ),
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.black), // Set text color to black
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform sign-in action here
      String? message = await context
          .read<UserAuthProvider>()
          .authService
          .signIn(context, _email!, _password!);

      if (message == "Success") {
        // Determine the user role and act accordingly
        UserRole userRole = await _getUserRole(_email!);
        if (userRole == UserRole.organization) {
          bool approved = await _isOrganizationApproved(_email!);
          if (approved) {
            Navigator.pushReplacementNamed(context, '/orghome');
          } else {
            // Show Snackbar and reset form
            _showOrganizationNotApprovedSnackbar();
            context.read<UserAuthProvider>().signOut();
            setState(() {
              _formKey.currentState!.reset();
            });
          }
        } else {
          // Navigate to other home pages
          switch (userRole) {
            case UserRole.donor:
              Navigator.pushReplacementNamed(context, '/donorhome');
              break;
            case UserRole.admin:
              Navigator.pushReplacementNamed(context, '/adminhome');
              break;
            default:
              Navigator.pushReplacementNamed(context, '/');
              break;
          }
        }
      } else {
        // Error occurred during sign-in, Snackbar already displayed by signIn method
        setState(() {
          _showSignInErrorMessage = true;
        });
      }
    }
  }

  Widget _navigateToHomePage(UserRole userRole, String email) {
    switch (userRole) {
      case UserRole.donor:
        return DonorHomePage();
      case UserRole.organization:
        return OrgHomePage();
      case UserRole.admin:
        return AdminHomePage();
      default:
        return Scaffold(
          body: Center(
            child: Text("Unknown role"),
          ),
        );
    }
  }

  Future<UserRole> _getUserRole(String? email) async {
    if (email == "admin@gmail.com") {
      return UserRole.admin;
    } else if (email != null && await _isEmailInOrganization(email)) {
      return UserRole.organization;
    } else {
      return UserRole.donor; // Default to donor
    }
  }

  Future<bool> _isEmailInOrganization(String email) async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('organization')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> _isOrganizationApproved(String email) async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('organization')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final orgData = querySnapshot.docs.first.data();
      return orgData['approval'] ?? false;
    } else {
      return false;
    }
  }

  void _showOrganizationNotApprovedSnackbar() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Organization sign up is not yet approved."),
        ),
      );
    });
  }
}

enum UserRole {
  donor,
  organization,
  admin,
}
