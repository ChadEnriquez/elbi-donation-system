import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/donor/drawer.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:elbi_donation_app/model/organization.dart';
import 'package:flutter/material.dart';

class DonorDonationPage extends StatefulWidget {
  final List donation;
  const DonorDonationPage({super.key, required this.donation});

  @override
  State<DonorDonationPage> createState() => _DonorDonationPageState();
}

class _DonorDonationPageState extends State<DonorDonationPage> {
  late Future<Map<String, Map<String, dynamic>>> orgs;

  @override
  void initState() {
    orgs = fetchOrganizations();
    super.initState();
  }

  Future<Map<String, Map<String, dynamic>>> fetchOrganizations() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("organization").limit(1).get();
    Map<String, Map<String, dynamic>> organizationsMap = {};
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      final org = Organization.fromJson(doc.data() as Map<String, dynamic>);
      organizationsMap[doc.id] = {"id": doc.id, "data": org};
    }
    return organizationsMap;
  }

  // Future<Map<String, Map<String, dynamic>>> fetchOrganizations() async {
  //   QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("organization").get();
  //   Map<String, Map<String, dynamic>> organizationsMap = {};
  //   for (var doc in snapshot.docs) {
  //     final org = Organization.fromJson(doc.data() as Map<String, dynamic>);
  //     organizationsMap[doc.id] = {"id": doc.id, "data": org};
  //   }
  //   return organizationsMap;
  // }

  @override
  Widget build(BuildContext context) {
    List donations = widget.donation;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "Donations",
          style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("donations").snapshots(),
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
            return const Center(
              child: Text("No Donations Yet", style: TextStyle(fontSize: 30, color: Colors.white, fontStyle: FontStyle.italic)),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: donations.length,
                    itemBuilder: ((context, index) {
                      final donation = Donation.fromJson(snapshot.data?.docs[index].data() as Map<String, dynamic>);
                      final donationID = snapshot.data?.docs[index].id;
                      if (donations.contains(donationID)) {
                        return FutureBuilder(
                          future: orgs,
                          builder: (context, orgsSnapshot) {
                            if (orgsSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              Map<String, Map<String, dynamic>> organizationsMap = orgsSnapshot.data as Map<String, Map<String, dynamic>>;
                              final orgId = organizationsMap[donation.orgID]?["id"] ?? "";
                              final orgName = organizationsMap[donation.orgID]?["data"]?.name ?? "Unknown Organization";
                              return ListTile(
                                title: Text(orgName, style: const TextStyle(fontSize: 20, color: Colors.white), softWrap: true),
                                subtitle: Text("Donation Drive: ", style: const TextStyle(fontSize: 10, color: Colors.white), softWrap: true),
                                trailing: IconButton(
                                  onPressed: () {
                                    // Delete donation logic here
                                  },
                                  icon: const Icon(Icons.delete_outlined, color: Colors.white),
                                ),
                                onTap: () {
                                  // Navigate to donation details page
                                },
                                contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                hoverColor: Colors.blueGrey[800],
                              );
                            }
                          },
                        );
                      }
                      return const SizedBox(); // Placeholder for other cases
                    }),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Back", style: TextStyle(fontSize: 15, color: Colors.white)),
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
