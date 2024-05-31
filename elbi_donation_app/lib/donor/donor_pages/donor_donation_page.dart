import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:elbi_donation_app/model/organization.dart';
import 'package:flutter/material.dart';

class DonorDonationPage extends StatefulWidget {
  final List donationData;
  const DonorDonationPage({super.key, required this.donationData});

  @override
  State<DonorDonationPage> createState() => _DonorDonationPageState();
}

class _DonorDonationPageState extends State<DonorDonationPage> {
  @override
  Widget build(BuildContext context) {
    List donations = widget.donationData;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(199, 177, 152, 1),
      appBar: AppBar(
        title: const Text(
          "Donations",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("donations").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error encountered! ${snapshot.error}",
                style: const TextStyle(fontSize: 30, color: Colors.white, fontStyle: FontStyle.italic),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No Donations Yet",
                style: TextStyle(fontSize: 30, color: Colors.black, fontStyle: FontStyle.italic),
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final donationData = snapshot.data!.docs[index].data();
                      final donation = Donation.fromJson(donationData);
                      final donationID = snapshot.data!.docs[index].id;
                      if (donations.contains(donationID)) {
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
                              final data = [[donationID, donation], org, null];
                              if (donation.donationDriveID.isEmpty) {
                                return Card(
                                  color: Colors.black,
                                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  child: ListTile(
                                    title: Text(
                                      org.name,
                                      style: const TextStyle(fontSize: 18, color: Colors.white),
                                      softWrap: true,
                                    ),
                                    subtitle: const Text(
                                      "Donation Drive: None",
                                      style: TextStyle(fontSize: 15, color: Colors.white),
                                      softWrap: true,
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, "/DonorDonationDetails", arguments: data);
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
                                      final driveName = driveData['name'];
                                      final data = [[donationID, donation], org, driveData];
                                      return Card(
                                        color: Colors.black,
                                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                        child: ListTile(
                                          title: Text(
                                            org.name,
                                            style: const TextStyle(fontSize: 18, color: Colors.white),
                                            softWrap: true,
                                          ),
                                          subtitle: Text(
                                            "Donation Drive: $driveName",
                                            style: const TextStyle(fontSize: 15, color: Colors.white),
                                            softWrap: true,
                                          ),
                                          onTap: () {
                                            Navigator.pushNamed(context, "/DonorDonationDetails", arguments: data);
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
                      }
                      return const SizedBox(); // Placeholder for other cases
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
