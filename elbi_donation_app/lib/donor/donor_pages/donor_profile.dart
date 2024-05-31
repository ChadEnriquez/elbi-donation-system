import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/authentication/builders/address_Field.dart';
import 'package:elbi_donation_app/donor/drawer.dart';
import 'package:elbi_donation_app/model/donor.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:elbi_donation_app/provider/donor_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DonorProfile extends StatefulWidget {
  const DonorProfile({super.key});

  @override
  State<DonorProfile> createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {
  User? user;
  
  @override
  Widget build(BuildContext context) {
    user = context.read<UserAuthProvider>().user;
    context.read<DonorProvider>().getDonor(user!.email);
    List<dynamic> donorData = context.read<DonorProvider>().donor;
    String donorID = donorData[0];
    Donor donor = donorData[1];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "Donor Profile",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("donors").doc(donorID).snapshots(),
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
                " ",
                style: TextStyle(fontSize: 30, color: Colors.white, fontStyle: FontStyle.italic),
              ),
            );
          } else {
            final donorData = snapshot.data!.data() as Map<String, dynamic>;
            final donor = Donor.fromJson(donorData);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserInfoRow("Full Name", donor.name, donor, donorID),
                        _buildUserInfoRow("Email", donor.email, donor, donorID),
                        _buildUserInfoRow("Contact Number", donor.contactno, donor, donorID),
                        _buildAddressSection("Address", donor.address, donor, donorID),
                        _buildUserInfoDonations(donor, donorID),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildUserInfoRow(String title, String value, Donor donor, String donorID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            if (title != "Email") {
              showDialog(
                context: context,
                builder: (BuildContext context) => _createAlertDialog(context, donor, donorID, title),
              );
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAddressSection(String title, List<String> values, Donor donor, String donorID) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 5),
      Column(
        children: values
            .asMap()
            .entries
            .map(
              (entry) => Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        values.removeAt(entry.key);
                        context.read<DonorProvider>().editDonorAddress(donorID, values);
                      });
                    },
                  ),
                ],
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 5),
      Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => _createAlertDialog(context, donor, donorID, "Address"),
            );
          },
          child: const Text("Add Address", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      const SizedBox(height: 5),
    ],
  );
}




  Widget _buildUserInfoDonations(Donor donor, String donorID) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Donations",
          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/DonorDonationsPage", arguments: donor.donations);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "View Donations",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                Icon(Icons.arrow_right_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _createAlertDialog(BuildContext context, Donor donor, String? donorID, String type) {
  var information = <String, dynamic>{
    "name": donor.name,
    "contactno": donor.contactno,
    "address": List.from(donor.address),
  };

  var newAddress = "";

  switch (type) {
    case 'Full Name':
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 53, 53, 53),
        content: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: TextFormField(
            initialValue: donor.name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Name",
            ),
            onChanged: (value) => information['name'] = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your name";
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel', style: TextStyle(fontSize: 15)),
          ),
          TextButton(
            onPressed: () async {
              context.read<DonorProvider>().editDonorDetails(donorID, "name", information["name"]);
              Navigator.pop(context, 'Edit');
              setState(() {}); // Update the state to trigger a rebuild
            },
            child: const Text('Edit', style: TextStyle(fontSize: 15, color: Colors.green)),
          ),
        ],
      );
    case 'Contact Number':
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 53, 53, 53),
        content: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: TextFormField(
            initialValue: donor.contactno,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Contact Number",
            ),
            onChanged: (value) => information['contactno'] = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your contact number";
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel', style: TextStyle(fontSize: 15)),
          ),
          TextButton(
            onPressed: () async {
              context.read<DonorProvider>().editDonorDetails(donorID, "contactno", information["contactno"]);
              Navigator.pop(context, 'Edit');
              setState(() {}); // Update the state to trigger a rebuild
            },
            child: const Text('Edit', style: TextStyle(fontSize: 15, color: Colors.green)),
          ),
        ],
      );
    case 'Address':
      List<String> addresses = List.from(information['address']);
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 53, 53, 53),
        content: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: TextFormField(
            initialValue: newAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Address",
            ),
            onChanged: (value) => newAddress = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your contact number";
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel', style: TextStyle(fontSize: 15)),
          ),
          TextButton(
            onPressed: () async {
              addresses.add(newAddress);
              context.read<DonorProvider>().editDonorAddress(donorID, addresses);
              Navigator.pop(context, 'Add');
              setState(() {}); // Update the state to trigger a rebuild
            },
            child: const Text('Edit', style: TextStyle(fontSize: 15, color: Colors.green)),
          ),
        ],
      );

    default:
      return const Column();
  }
}


}
