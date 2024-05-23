import 'package:elbi_donation_app/donor/drawer.dart';
import 'package:flutter/material.dart';


class DonorProfile extends StatefulWidget {
  const DonorProfile({super.key});

  @override
  State<DonorProfile> createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "Donor",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text("Donor Profile", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
      )
    );
  }
}