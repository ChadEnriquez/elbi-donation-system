import 'package:elbi_donation_app/admin/for_approvals.dart';
import 'package:elbi_donation_app/admin/view_donations.dart';
import 'package:elbi_donation_app/admin/view_organizations.dart';

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
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ViewDonorsPage(),
    ViewOrganizationsPage(),
    ViewDonationsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 177, 152, 1),
      appBar: AppBar(
        title: const Text(
          "Elbination Admin",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Color.fromRGBO(199, 177, 152, 1)), // Black icon color
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, 
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color.fromRGBO(199, 177, 152, 0.567)), 
            activeIcon: Icon(Icons.person, color: Color.fromRGBO(199, 177, 152, 1)), 
            label: 'Donors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business, color: Color.fromRGBO(199, 177, 152, 0.567)), 
            activeIcon: Icon(Icons.business, color: Color.fromRGBO(199, 177, 152, 1)), 
            label: 'Organizations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard, color: Color.fromRGBO(199, 177, 152, 0.567)), 
            activeIcon: Icon(Icons.card_giftcard, color: Color.fromRGBO(199, 177, 152, 1)), 
            label: 'Donations',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(199, 177, 152, 1),
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(199, 177, 152, 1),
              ),
              child: Text(
                'Admin Menu', style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold))
            ),
            ListTile(
              title: const Text('For approvals', style: TextStyle(fontSize: 20, color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApprovalsPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Logout', style: TextStyle(fontSize: 20, color: Colors.white)),
              onTap: () {
                context.read<UserAuthProvider>().signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}

