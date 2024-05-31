import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/donor/drawer.dart';
import 'package:elbi_donation_app/model/organization.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:elbi_donation_app/provider/donor_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DonorHomePage extends StatefulWidget {
  const DonorHomePage({super.key});

  @override
  State<DonorHomePage> createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  User? user;

  @override
  Widget build(BuildContext context) {
    user = context.read<UserAuthProvider>().user;
    context.read<DonorProvider>().getDonor(user!.email);
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 177, 152, 1),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Color.fromRGBO(199, 177, 152, 1),
            child: Center(
              child: Text(
                "List of Organizations",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("organization").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error encountered! ${snapshot.error}", style: const TextStyle(fontSize: 30, color: Colors.white, fontStyle: FontStyle.italic),),
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Organizations Found", style: TextStyle(fontSize: 30, color: Colors.white, fontStyle: FontStyle.italic)),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      final org = Organization.fromJson(snapshot.data?.docs[index].data() as Map<String, dynamic>);
                      final orgID = snapshot.data?.docs[index].id;
                      final orgData = [orgID, org];
                      return Card(
                        color: Colors.black,
                        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                        child: ListTile(
                          leading: Icon(Icons.account_circle_rounded, color: Colors.white, size: 30),
                          title: Text(org.name, style: TextStyle(fontSize: 20, color: Colors.white), softWrap: true),
                          subtitle: Text(org.status ? 'Open for Donations' : 'Closed for Donations', style: TextStyle(fontSize: 16, color: org.status ? Colors.green : Colors.red)),
                          onTap: org.status ? () {
                            Navigator.pushNamed(context, "/DonationDrivesPage", arguments: orgData);
                          } : null,
                        ),
                      );
                    }),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

