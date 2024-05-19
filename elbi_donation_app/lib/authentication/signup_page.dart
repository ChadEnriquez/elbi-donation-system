import 'package:elbi_donation_app/admin/admin_home_page.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum UserType { Donor, Organization}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? email;
  String? password;
  String? address;
  String? contactno;
  UserType? selectedUserType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                heading,
                userTypeDropdown,
                if (selectedUserType != null) ..._buildSignupFields(selectedUserType!)
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
          "Sign Up",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  Widget get userTypeDropdown => DropdownButtonFormField<UserType>(
        value: selectedUserType ?? UserType.Donor, // Set default value to UserType.Donor
        onChanged: (value) {
          setState(() {
            selectedUserType = value;
          });
        },
        items: UserType.values
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                ))
            .toList(),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'User Type',
        ),
      );

  List<Widget> _buildSignupFields(UserType userType) {
    switch (userType) {
      case UserType.Donor:
        return [
          SizedBox(height: 20),
          nameField,
          SizedBox(height: 20),
          emailField,
          SizedBox(height: 20),
          passwordField,
          SizedBox(height: 20),
          addressField,
          SizedBox(height: 20),
          contactField,
          SizedBox(height: 20),
          submitButton
        ];
      case UserType.Organization:
        return [
          SizedBox(height: 20),
          nameOrgField,
          SizedBox(height: 20),
          emailOrgField,
          SizedBox(height: 20),
          passwordField,
          SizedBox(height: 20),
          addressField,
          SizedBox(height: 20),
          contactField,
          //, proof(photo daw huhuhu pano gawin itue)
          SizedBox(height: 20),
          submitButtonOrg
        ];
    }
  }

  Widget get emailField => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
        ),
        onSaved: (value) => setState(() => email = value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a valid email';
          }
          return null;
        },
      );
  Widget get emailOrgField => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          hintText: 'org@organization.com',
        ),
        onSaved: (value) => setState(() => email = value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a valid email';
          }
          return null;
        },
      );

  Widget get passwordField => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
        ),
        obscureText: true,
        onSaved: (value) => setState(() => password = value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a valid password';
          }
          return null;
        },
      );

  Widget get nameField => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(), label: Text("Name")),
          onSaved: (value) => setState(() => name = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your name";
            }
            return null;
          },
        ),
      );

  Widget get nameOrgField => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Name of Organization")),
          onSaved: (value) => setState(() => name = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your organization's name";
            }
            return null;
          },
        ),
      );

  Widget get addressField => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(), label: Text("Address")),
          onSaved: (value) => setState(() => address = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid address";
            }
            return null;
          },
        ),
      );

  Widget get contactField => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(), label: Text("Contact number")),
          onSaved: (value) => setState(() => contactno = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a contact number";
            }
            return null;
          },
        ),
      );

  Widget get submitButton => ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await context
                .read<UserAuthProvider>()
                .authService
                .signUp(email!, password!, name!, address!, contactno!);

            // check if the widget hasn't been disposed of after an asynchronous action
            if (mounted) Navigator.pop(context);
          }
        },
        child: const Text('Sign Up'));

  Widget get submitButtonOrg => ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            await context
                .read<UserAuthProvider>()
                .authService
                .signUpOrg(email!, password!, name!, address!, contactno!);

            // check if the widget hasn't been disposed of after an asynchronous action
            if (mounted) Navigator.pop(context);
          }
        },
        child: const Text('Sign Up'));
}
