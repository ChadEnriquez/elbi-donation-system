import 'package:elbi_donation_app/authentication/signin_adminpage.dart';
import 'package:elbi_donation_app/authentication/signin_orgpage.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool showSignInErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 100, horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                heading,
                emailField,
                passwordField,
                showSignInErrorMessage ? signInErrorMessage : Container(),
                submitButton,
                SizedBox(
                  height: 20.0, // Adjust as needed
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150.0, // Adjust as needed
                      child: Container(
                        color: Colors.grey.withOpacity(0.2), // Change color as needed
                        height: 1.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.5), // Change color as needed
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150.0, // Adjust as needed
                      child: Container(
                        color: Colors.grey.withOpacity(0.2), // Change color as needed
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0, // Adjust as needed
                ),
                signInOptions,
                signUpButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Sign In",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  Widget get emailField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Email"),
              hintText: "juandelacruz09@gmail.com"),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your email";
            }
            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Password"),
              hintText: "******"),
          obscureText: true,
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your password";
            }
            return null;
          },
        ),
      );

  Widget get signInErrorMessage => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Invalid email or password",
          style: TextStyle(color: Colors.red),
        ),
      );

  Widget get submitButton => ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          String? message = await context
              .read<UserAuthProvider>()
              .authService
              .signIn(email!, password!);

          print(message);
          print(showSignInErrorMessage);

          setState(() {
            if (message != null && message.isNotEmpty) {
              showSignInErrorMessage = true;
            } else {
              showSignInErrorMessage = false;
            }
          });
        }
      },
      style: ElevatedButton.styleFrom(
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
          ),
        ),
      child: const Text("Sign In", 
                  style: TextStyle(color: Colors.white)
                  ), 
            );
          
  Widget get signInOptions => Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInOrgPage(),
            ),
          );
            },
            child: const Text(
              "Sign in as an Organization",
              style: TextStyle(
                color: Colors.white, // Adjust text color as needed
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInAdminPage(),
            ),
          );
            },
            child: const Text(
              "Sign in as Admin",
              style: TextStyle(
                color: Colors.white, // Adjust text color as needed
              ),
            ),
          ),
        ],
      ),
    );


  Widget get signUpButton => Padding(
  padding: const EdgeInsets.all(30),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "No account yet?",
        style: TextStyle(color: Colors.white), // Optionally, make this text black
      ),
      SizedBox(height: 10.0),
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
);

}
