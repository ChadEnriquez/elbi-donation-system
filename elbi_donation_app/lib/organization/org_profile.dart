import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrgProfilePage extends StatefulWidget {
  const OrgProfilePage({super.key});
  @override
  OrgProfilePageState createState() => OrgProfilePageState();
}

class OrgProfilePageState extends State<OrgProfilePage> {
  User? organization;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    organization = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Organization Profile"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('organization')
            .doc(organization?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No data found'));
          }

          final orgData = snapshot.data!.data() as Map<String, dynamic>;
          final orgAddress = orgData['address'];
          final orgPhone = orgData['contactno'];
          final orgEmail = orgData['email'];
          final orgName = orgData['name'];
          var orgDescription = orgData['description'];
          var orgStatus = orgData['status'];

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'lib/assets/org_profilepic.png',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("$orgName", style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Description: ${orgDescription ?? 'No Organization Description Yet Found'}",
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Edit Description"),
                                content: Form(
                                  key: _formKey,
                                  child: SingleChildScrollView(
                                    child: TextFormField(
                                      initialValue: orgDescription,
                                      maxLines: null,
                                      onSaved: (value) {
                                        orgDescription = value;
                                      },
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    child: const Text("Save"),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        FirebaseFirestore.instance
                                            .collection('organization')
                                            .doc(organization!.uid)
                                            .update({
                                          'description': orgDescription,
                                        });
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 1.0,
                  ),
                  const SizedBox(height: 10),
                  Text("Email: ${orgEmail ?? 'No Organization Email Found'}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  Text(
                      "Address: ${orgAddress ?? 'No Organization Address Found'}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  Text(
                      "Phone: ${orgPhone ?? 'No Organization Phone Number Found'}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Still Accepting Donations?', style: TextStyle(fontSize: 16)),
                      Switch(
                        value: orgStatus,
                        onChanged: (bool value) {
                          setState(() {
                            orgStatus = value;
                          });
                          // Update orgStatus in Firebase
                          FirebaseFirestore.instance
                              .collection('organization')
                              .doc(organization!.uid)
                              .update({
                            'status': orgStatus,
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
