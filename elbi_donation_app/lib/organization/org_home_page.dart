import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'org_profile.dart';

class OrgHomePage extends StatelessWidget {
  const OrgHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
      drawer: const OrgDrawer(), // Added drawer
      body: const Column(
        children: [
          Align(
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
          SizedBox(height: 20.0),
          OrganizationListItem(
            orgName: "Donation 1",
            orgId: "org1Id", // Replace with actual ID from Firestore
          ),
          OrganizationListItem(
            orgName: "Donation 2",
            orgId: "org2Id", // Replace with actual ID from Firestore
          ),
          OrganizationListItem(
            orgName: "Donation 3",
            orgId: "org3Id", // Replace with actual ID from Firestore
          ),
        ],
      ),
    );
  }
}

class OrganizationListItem extends StatelessWidget {
  final String orgName;
  final String orgId;

  const OrganizationListItem({
    super.key,
    required this.orgName,
    required this.orgId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrgProfilePage()),
          );
        },
        child: Card(
          child: ListTile(
            title: Text(orgName, textAlign: TextAlign.center),
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
              // Navigate to the organization profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrgProfilePage()),
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
