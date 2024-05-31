import 'package:elbi_donation_app/organization/org_donation_drive_page.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DonationsList(),
    OrgDonationDrivePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Homepage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta),
            label: 'Drives',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
      drawer: const OrgDrawer(),
    );
  }
}

class DonationsList extends StatelessWidget {
  const DonationsList({super.key});

  @override
  Widget build(BuildContext context) {
    final User? organization = FirebaseAuth.instance.currentUser;

    if (organization == null) {
      return const Center(child: Text('No organization logged in'));
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('organization')
          .doc(organization.uid)
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

        List<dynamic> donationIds = snapshot.data!['donations'] ?? [];

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'List of Donations',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: donationIds.length,
                itemBuilder: (context, index) {
                  String donationId = donationIds[index];
                  return DonationCard(donationId: donationId);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class DonationCard extends StatelessWidget {
  final String donationId;

  const DonationCard({
    required this.donationId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: ListTile(
        title: Text(
          'Donation ID: $donationId',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            title: const Text('Donation Drives'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Navigate to the Donation Drive page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OrgDonationDrivePage()),
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
