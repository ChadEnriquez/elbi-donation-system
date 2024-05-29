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
      body: StreamBuilder(
        stream: context.watch<UserAuthProvider>().userStream,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error encountered! ${snapshot.error}"),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (!snapshot.hasData) {
            return _buildSignInForm();
          } else {
            // User is already signed in, navigate to the appropriate home page
            return FutureBuilder<UserRole>(
              future: _getUserRole(snapshot.data!.email),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (roleSnapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error determining role: ${roleSnapshot.error}"),
                    ),
                  );
                } else {
                  return _navigateToHomePage(roleSnapshot.data!, snapshot.data!.email!);
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildSignInForm() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  "Sign In",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    hintText: "juandelacruz09@gmail.com",
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "******",
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
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                    ),
                  ),
                  child: const Text("Sign In", style: TextStyle(color: Colors.white)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No account yet?",
                      style: TextStyle(color: Colors.white), // Optionally, make this text black
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
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white), // Make text white
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
        return FutureBuilder<bool>(
          future: _isOrganizationApproved(email),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error determining organization approval status: ${snapshot.error}"),
                ),
              );
            } else {
              bool approved = snapshot.data ?? false;
              if (approved) {
                return OrgHomePage();
              } else {
                // Organization not approved, show Snackbar and return to sign-in page
                _showOrganizationNotApprovedSnackbar();
                return _buildSignInForm();
              }
            }
          },
        );
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
