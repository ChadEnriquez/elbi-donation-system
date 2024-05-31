import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:elbi_donation_app/model/organization.dart';
import 'package:elbi_donation_app/organization/org_donation_drive_page.dart';
import 'package:elbi_donation_app/organization/qrscanner.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:elbi_donation_app/provider/organization_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'org_profile.dart';

class OrgHomePage extends StatefulWidget {
  const OrgHomePage({super.key});

  @override
  State<OrgHomePage> createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
  bool loading = true;
  late Future<void> _fetchOrgDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchOrgDataFuture = fetchOrgData();
  }

  Future<void> fetchOrgData() async {
    User? user = context.read<UserAuthProvider>().user;
    if (user != null) {
      await context.read<OrganizationProvider>().getOrg(user.email);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = context.read<UserAuthProvider>().user;
    context.read<OrganizationProvider>().getOrg(user!.email);
    List<dynamic> orgData = context.read<OrganizationProvider>().currentOrg;
    String orgID = orgData[0];
    Organization org = orgData[1];
    int donationNumber = 0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      appBar: AppBar(
        title: const Text(
          "Organization Homepage",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const OrgDrawer(),
      body: loading ? const Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: FirebaseFirestore.instance.collection("donations").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error encountered! ${snapshot.error}",
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Donations Found",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("List of Donations",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal)),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final donationData = snapshot.data!.docs[index].data();
                            final donation = Donation.fromJson(donationData);
                            final donationID = snapshot.data!.docs[index].id;

                            if (org.donations.contains(donationID)) {
                              if (donation.donationDriveID.isEmpty) {
                                donationNumber++;
                                final data = [[donationID, donation], org, null];
                                print(data);
                                return Card(
                                  color: const Color.fromARGB(255, 43, 43, 43),
                                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  child: ListTile(
                                    title: Text(
                                      "Donation $donationNumber",
                                      style: const TextStyle(fontSize: 20, color: Colors.white),
                                      softWrap: true,
                                    ),
                                    subtitle: const Text(
                                      "Donation Drive: None",
                                      style: TextStyle(fontSize: 15, color: Colors.white),
                                      softWrap: true,
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, "/OrgDonationDetailsPage", arguments: data);
                                    },
                                  ),
                                );
                              } else {
                                return StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection("donation-drives").doc(donation.donationDriveID).snapshots(),
                                  builder: (context, driveSnapshot) {
                                    if (driveSnapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else {
                                      final driveData = driveSnapshot.data!.data() as Map<String, dynamic>;
                                      final driveName = driveData['name'];
                                      final data = [[donationID, donation], org, driveData];
                                      print(data);
                                      return Card(
                                        color: const Color.fromARGB(255, 43, 43, 43),
                                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                        child: ListTile(
                                          title: Text(
                                            org.name,
                                            style: const TextStyle(fontSize: 20, color: Colors.white),
                                            softWrap: true,
                                          ),
                                          subtitle: Text(
                                            "Donation Drive: $driveName",
                                            style: const TextStyle(fontSize: 15, color: Colors.white),
                                            softWrap: true,
                                          ),
                                          onTap: () {
                                            Navigator.pushNamed(context, "/OrgDonationDetailsPage", arguments: data);
                                          },
                                        ),
                                      );
                                    }
                                  },
                                );
                              }
                            }
                            return Container(); // Return an empty container if the donation is not in the org's donations list
                          },
                        ),
                      ),
                    scanner(),
                    const SizedBox(height: 20,)
                    ],
                  
                  );
                }
              },
            ),
    );
  }

  Widget scanner() {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        icon: const Icon(Icons.qr_code),
        label: const Text('QR Scanner', style: TextStyle(fontSize: 15)),
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => const OrgScanQRCodePage()),
          );
        },
      ),
    );
  }
}


class OrganizationListItem extends StatelessWidget {
  final String donation;
  final String? orgId;
  final VoidCallback? onTap;

  const OrganizationListItem({
    required this.donation,
    required this.orgId,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: Colors.blueGrey,
          child: ListTile(
            title: Text(donation, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

class OrgDrawer extends StatelessWidget {
  const OrgDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Organization Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Organization Profile'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrgProfilePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Donation Drives'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrgDonationDrivePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              context.read<UserAuthProvider>().signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
