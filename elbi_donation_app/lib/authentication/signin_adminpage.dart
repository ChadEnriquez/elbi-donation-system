import 'package:elbi_donation_app/admin/admin_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';

class SignInAdminPage extends StatefulWidget {
  const SignInAdminPage({Key? key}) : super(key: key);

  @override
  State<SignInAdminPage> createState() => _SignInAdminPageState();
}

class _SignInAdminPageState extends State<SignInAdminPage> {
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
              labelText: "Email",
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
              labelText: "Password",
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
            String? message =
                await context.read<UserAuthProvider>().authService.signIn(email!, password!);
            
            print(message);
            print(showSignInErrorMessage);

            setState(() {
              if (message != null && message.isNotEmpty) {
                showSignInErrorMessage = true;
              } else {
                showSignInErrorMessage = false;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminHomePage()),
                );
              }
            });
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Adjust the radius as needed
          ),
        ),
        child: const Text(
          "Sign In",
          style: TextStyle(color: Colors.white),
        ),
      );
}
