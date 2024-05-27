import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/organization/org_donation_drive_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: OrgDonationDrivePage(),
  ));
}

class OrgDonationDrivePage extends StatefulWidget {
  const OrgDonationDrivePage({super.key});

  @override
  OrgDonationDrivePageState createState() => OrgDonationDrivePageState();
}

class OrgDonationDrivePageState extends State<OrgDonationDrivePage> {
  final List<String> donationDrives = [];

  @override
  Widget build(BuildContext context) {
    final organization = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Drives'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donation-drives')
            .where('organizationID', isEqualTo: organization?.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data?.docs.isEmpty ?? true) {
            return const Center(child: Text('No Donation Drives Available'));
          }

          // displays the donotation-drives
          // based on the order in firestore database
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Center(child: Text(data['name'])), // Centered text
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DonationDriveDetailPage(
                          driveId: document.id,
                          driveName: data['name'],
                        ),
                      ),
                    );
                  }, // onPressed that does nothing
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final TextEditingController controller = TextEditingController();
          final driveName = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('New Donation Drive'),
                content: TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Donation Drive Name',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Save'),
                    onPressed: () {
                      Navigator.of(context).pop(controller.text);
                    },
                  ),
                ],
              );
            },
          );

          if (driveName != null && driveName.isNotEmpty) {
            final organization = FirebaseAuth.instance.currentUser;
            await FirebaseFirestore.instance.collection('donation-drives').add({
              'name': driveName,
              'organizationID': organization?.uid,
              'donationID': [], // Empty array for donationID
            });

            setState(() {
              donationDrives.add(driveName);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
