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
          print(orgData);
          final orgAddress = orgData['address'];
          final orgPhone = orgData['contactno'];
          final orgEmail = orgData['email'];
          final orgName = orgData['name'];
          // final orgApproval = orgData['approval'];
          // final orgDescription = orgData['description'];
          // final orgDonations = orgData['donations'];
          // final orgProof = orgData['proof'];
          // final orgStatus = orgData['status'];
          

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Organization Name: ${orgName ?? 'No Organization Name Found'}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  Text("Email: ${orgEmail ?? 'No Organization Email Found'}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  Text("Address: ${orgAddress?? 'No Organization Address Found'}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  Text("Phone: ${orgPhone?? 'No Organization Phone Number Found'}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}