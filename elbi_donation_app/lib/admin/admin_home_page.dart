import 'view_donors.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Card(
              color: const Color.fromARGB(255, 48, 48, 48),
              child: Container(
                height: 100,  
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text(
                    'Donors',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,  
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewDonorsPage()),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),  
            Card(
              color: const Color.fromARGB(255, 48, 48, 48),
              child: Container(
                height: 100,  
                child: ListTile(
                  leading: const Icon(Icons.business, color: Colors.white),
                  title: const Text(
                    'Organizations',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,  
                    ),
                  ),
                  onTap: () {
                    // Navigate to View Organizations page
                  },
                ),
              ),
            ),
            SizedBox(height: 16),  
            Card(
              color: const Color.fromARGB(255, 48, 48, 48),
              child: Container(
                height: 100,  
                child: ListTile(
                  leading: const Icon(Icons.card_giftcard, color: Colors.white),
                  title: const Text(
                    'Donations',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,  // Increase the font size
                    ),
                  ),
                  onTap: () {
                    // Navigate to View Donations page
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 48, 48, 48),
              ),
              child: const Text(
                'Navigation',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('For approvals'),
              onTap: () {
                // Navigate to approvals page
              },
            ),
            ListTile(
              title: const Text('View Donors'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewDonorsPage()),
                );
              },
            ),
            ListTile(
              title: const Text('View Organizations'),
              onTap: () {
                // Navigate to View Organizations page
              },
            ),
            ListTile(
              title: const Text('View Donations'),
              onTap: () {
                // Navigate to View Donations page
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                context.read<UserAuthProvider>().signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
