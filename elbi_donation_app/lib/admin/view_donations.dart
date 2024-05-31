import 'package:elbi_donation_app/model/organization.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:elbi_donation_app/donor/donor_pages/donor_donation_details.dart';

class ViewDonationsPage extends StatelessWidget {
  const ViewDonationsPage({Key? key}) : super(key: key);

  Future<List<Donation>> _fetchDonations() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('donations').get();
    return querySnapshot.docs.map((doc) => Donation.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 177, 152, 1),
      body: FutureBuilder<List<Donation>>(
        future: _fetchDonations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No donations found'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  color: Color.fromRGBO(199, 177, 152, 1),
                  child: Center(
                    child: Text(
                      "List of Donations",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded (
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final donation = snapshot.data![index];
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("organization").doc(donation.orgID).snapshots(),
                          builder: (context, orgSnapshot) {
                            if (orgSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              final orgData = orgSnapshot.data!.data() as Map<String, dynamic>;
                              final org = Organization.fromJson(orgData);
                              final data = [donation, org, null];
                              if (donation.donationDriveID.isEmpty) {
                                return Card(
                                  color: Colors.black,
                                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                                  child: ListTile(
                                    title: Text('Donation ID: ${index + 1}'),
                                    subtitle: Text('Method: ${donation.method}'),
                                    onTap: () {
                                      Navigator.pushNamed(context, "/AdminDonationDetails", arguments: data);
                                    },
                                  ),
                                );
                              } else {
                                return StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection("donation-drives").doc(donation.donationDriveID).snapshots(),
                                  builder: (context, driveSnapshot) {
                                    if (driveSnapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      final driveData = driveSnapshot.data!.data() as Map<String, dynamic>;
                                      final data = [donation, org, driveData];
                                      return Card(
                                        color: Colors.black,
                                        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                                        child: ListTile(
                                          title: Text('Donation ID: ${index + 1}'),
                                          subtitle: Text('Method: ${donation.method}'),
                                          onTap: () {
                                            Navigator.pushNamed(context, "/AdminDonationDetails", arguments: data);
                                          },
                                        ),
                                      );
                                    }
                                  },
                                );
                              }
                            }
                          },
                        );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
