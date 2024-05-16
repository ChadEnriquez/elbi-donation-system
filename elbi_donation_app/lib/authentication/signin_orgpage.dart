import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'signup_page.dart';

class SignInOrgPage extends StatefulWidget {
  const SignInOrgPage({super.key});

  @override
  State<SignInOrgPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInOrgPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool showSignInErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                submitButton
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
              // Handle sign in as organization
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
              // Handle sign in as admin
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
