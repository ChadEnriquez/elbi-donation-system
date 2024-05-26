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
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      appBar: AppBar(
        title: const Text(
          "Admin",
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text("Admin Homepage",
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 48, 48, 48),
              ),
              child: Text('Navigation',
                  style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: Text('For approvals'),
              onTap: () {
                
              },
            ),
            ListTile(
              title: Text('View Donors'),
              onTap: () {
                
              },
            ),
            ListTile(
              title: Text('View Organizations'),
              onTap: () {
                
              },
            ),
            ListTile(
              title: Text('Logout'),
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
