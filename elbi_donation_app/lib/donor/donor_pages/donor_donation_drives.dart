import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/donor/drawer.dart';
import 'package:elbi_donation_app/model/donation_drive.dart';
import 'package:elbi_donation_app/model/organization.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:elbi_donation_app/provider/donor_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DonationDrivesPage extends StatefulWidget {
  final List orgData; 
  const DonationDrivesPage({super.key, required this.orgData});

  @override
  State<DonationDrivesPage> createState() => _DonationDrivesPageState();
}

class _DonationDrivesPageState extends State<DonationDrivesPage> {
  
  @override
  Widget build(BuildContext context) {
    String orgID = widget.orgData[0];
    Organization org = widget.orgData[1];
    List orgData = [orgID, org];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text(org.name, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("donation-drives").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}", style: const TextStyle(fontSize: 30, color: Colors.white, fontStyle: FontStyle.italic),),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Column(
              children: [
                Text("No donation drives found", style: TextStyle(fontSize: 30, color: Colors.white, fontStyle: FontStyle.italic)),
              ]
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      final drive = DonationDrive.fromJson(snapshot.data?.docs[index].data() as Map<String, dynamic>);
                      final driveID = snapshot.data?.docs[index].id;
                      final driveData = [driveID, drive];
                      if (org.donationDrives.contains(driveID)) {
                        return ListTile(
                        title: Text(drive.name, style: const TextStyle(fontSize: 20, color: Colors.white), softWrap: true),
                        onTap: () {
                          Navigator.pushNamed(context, "/DonorDonationForm", arguments: driveData);
                        },
                      );
                      }
                    }
                    ),
                  )
                ),
                TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/DonorDonationForm", arguments: orgData);
                  }, 
                  child: const Text("Donate directly to Organization", style: TextStyle(fontSize: 20, color: Colors.white)),
                )
              ],
            );
          }
        },
      ),
    );
  }
}