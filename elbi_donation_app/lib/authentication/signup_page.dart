import 'dart:io';

import 'package:elbi_donation_app/authentication/builders/address_Field.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum UserType { Donor, Organization }

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
  List<String>? address;
  String? contactno;
  UserType? selectedUserType;

  // File details for organization proof
  String? filePath;
  File? file;

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
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
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
          AddressTextField(callback: (value) {
            setState(() {
              address = value;
            });
          }),
          SizedBox(height: 20),
          contactField,
          SizedBox(height: 20),
          submitButton
        ];
      case UserType.Organization:
        return [
          SizedBox(height: 20),
          nameField,
          SizedBox(height: 20),
          emailOrgField,
          SizedBox(height: 20),
          passwordField,
          SizedBox(height: 20),
          AddressTextField(callback: (value) {
            setState(() {
              address = value;
            });
          }),
          SizedBox(height: 20),
          contactField,
          SizedBox(height: 20),
          fileNameIndicator,
          proof,
          SizedBox(height: 20),
          submitButtonOrg
        ];
    }
  }

  Widget get emailField => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
          labelText: 'Email',
          prefixIcon: Icon(Icons.email),
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
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
          labelText: 'Email',
          hintText: 'org@organization.com',
          prefixIcon: Icon(Icons.email),
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
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock), // Add lock icon
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
          decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),), 
              label: Text("Name"),
              prefixIcon: Icon(Icons.people),
            ),
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
          decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
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

  Widget get contactField => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: TextFormField(
          decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),),
              label: Text("Contact number"),
              prefixIcon: Icon(Icons.phone)),
          onSaved: (value) => setState(() => contactno = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a contact number";
            }
            return null;
          },
        ),
      );

  Widget get proof => IconButton(
        onPressed: () {
          _openFilePicker(context);
        },
          icon: Icon(Icons.attach_file)
      );

  Widget get fileNameIndicator {
    if (filePath != null) {
      return Text(
        "Selected file: ${filePath!.split('/').last}", // file name only
        style: const TextStyle(
          color: Color.fromRGBO(221, 255, 254, 1),
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return const Text(
        "please attach the proof of legitimacy", // file name only
        style: TextStyle(
          color: Colors.white,
        ),
      );
    }
  }

  Future<void> _openFilePicker(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
        filePath = pickedFile.path;
      });
      print('Selected file path: $filePath');
    } else {
      // canceled 
      print('No file selected');
    }
  }

  Widget get submitButton => ElevatedButton(
    onPressed: () async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        await context
            .read<UserAuthProvider>()
            .authService
            .signUp(email!, password!, name!, address!, contactno!, context);

        // check if the widget hasn't been disposed of after an asynchronous action
        if (mounted) Navigator.pop(context);
      }
    },
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(199, 177, 152, 1)), // Set button color to beige
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
        ),
      ),
    ),
    child: const Text('Sign Up',
                        style: TextStyle(color: Colors.black))
  );

  Widget get submitButtonOrg => ElevatedButton(
    onPressed: () async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (file != null) {
          String fileURL = await uploadFile(); // Upload file first before signing up
          await context
              .read<UserAuthProvider>()
              .authService
              .signUpOrg(email!, password!, name!, address!, contactno!, fileURL, context);

          // Check if the widget hasn't been disposed of after an asynchronous action
          if (mounted) Navigator.pop(context);
        } else {
          // Handle the case where no file is selected
          print('Please select a proof file');
        }
      }
    },
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(199, 177, 152, 1)), // Set button color to beige
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
        ),
      ),
    ),
    child: const Text('Sign Up',
                        style: TextStyle(color: Colors.black))
  );

  Future<String> uploadFile() async {
    Reference storageRef = FirebaseStorage.instance.ref('orgProof/').child('$email-proof');

    UploadTask uploadTask = storageRef.putFile(file!);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String fileURL = await snapshot.ref.getDownloadURL();
    return fileURL;
  }
}
