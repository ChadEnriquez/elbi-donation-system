
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:elbi_donation_app/authentication/builders/address_Field.dart';
import 'package:elbi_donation_app/donor/builders/camera.dart';
//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:elbi_donation_app/provider/organization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum UserType { Donor, Organization}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

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
  String? description = "";
  bool status = false;
  UserType? selectedUserType = UserType.Donor;
  String? filePath;
  late XFile file;

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
          const SizedBox(height: 20),
          nameField,
          const SizedBox(height: 20),
          emailField,
          const SizedBox(height: 20),
          passwordField,
          const SizedBox(height: 20),
          AddressTextField(callback: (value) {
            setState(() {
              address = value;
            });
          }),
          const SizedBox(height: 20),
          contactField,
          const SizedBox(height: 20),
          submitButton
        ];
      case UserType.Organization:
        return [
          const SizedBox(height: 20),
          nameOrgField,
          const SizedBox(height: 20),
          emailField,
          const SizedBox(height: 20),
          passwordField,
          const SizedBox(height: 20),
          AddressTextField(callback: (value) {
            setState(() {
              address = value;
            });
          }),
          const SizedBox(height: 20),
          contactField,
          const SizedBox(height: 20),
          fileNameIndicator,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              filePickerButton,
              cameraButton
            ],
          ),
          const SizedBox(height: 20),
          submitButtonOrg
        ];
    }
  }

  Widget get emailField => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Email',
          prefixIcon: const Icon(Icons.email)
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          labelText: 'Password',
          prefixIcon: const Icon(Icons.lock)
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), 
              label: const Text("Name"),
              prefixIcon: const Icon(Icons.people)
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              label: const Text("Name of Organization"),
              prefixIcon:const  Icon(Icons.people)
            ),
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), 
              label: const Text("Contact number"),
              prefixIcon: const Icon(Icons.phone)
            ),
          onSaved: (value) => setState(() => contactno = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a contact number";
            }
            return null;
          },
        ),
      );

Future<void> _openFilePicker(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = XFile(pickedFile.path);;
        filePath = pickedFile.path;
      });
      print('Selected file path: $filePath');
    } else {
      // Canceled 
      print('No file selected');
    }
  }

  Widget get filePickerButton {
    return ElevatedButton.icon(
      onPressed: () {
        _openFilePicker(context);
      },
      icon: const Icon(Icons.attach_file),
      label: const Text("Attach Image"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(199, 177, 152, 1), 
        foregroundColor: Colors.black, 
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget get cameraButton {
    return ElevatedButton.icon(
      onPressed: () async {
        await availableCameras().then((value) => Navigator.push(context,
          MaterialPageRoute(builder: (_) => CameraPage(
            callback:(imageFile) 
            {setState(() {
               file = imageFile;
               filePath = file.path;
            });}, 
            cameras: value)
            )
          )
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(199, 177, 152, 1), 
        foregroundColor: Colors.black, 
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        ),
      ),
      icon: const Icon(Icons.camera_alt_rounded),
      label: const Text("Take Picture"),
    );
  }

  Widget get fileNameIndicator {
    if (filePath != null) {
      return Text(
        "Selected file: ${filePath!.split('/').last}", // File name only
        style: const TextStyle(
          color: Color.fromRGBO(221, 255, 254, 1),
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return const Text(
        "Please attach the proof of legitimacy", // Prompt text
        style: TextStyle(
          color: Colors.white,
        ),
      );
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
            
            if (mounted) Navigator.pop(context);
          }
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(199, 177, 152, 1)), // Set button color to beige
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
              ),
            ),
          ),
        child: const Text('Sign Up', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)));

  Widget get submitButtonOrg => ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            var orgID  = await context
                .read<UserAuthProvider>()
                .authService
                .signUpOrg(email!, password!, name!, address!, contactno!, context);
            String? photoURL = await context.read<OrganizationProvider>().addProofPhoto(file, orgID!);
            print("Photo URL: $photoURL");
            context.read<OrganizationProvider>().editProofimg(orgID, photoURL);            
            if (mounted) Navigator.pop(context);
          }
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(199, 177, 152, 1)), // Set button color to beige
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
              ),
            ),
          ),
        child: const Text('Sign Up', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)));
}