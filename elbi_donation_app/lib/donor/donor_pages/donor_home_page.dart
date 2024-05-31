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
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "List of Organizations",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
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
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      print(snapshot.data?.docs[index].data());
                      final org = Organization.fromJson(snapshot.data?.docs[index].data() as Map<String, dynamic>);
                  
                      final orgID = snapshot.data?.docs[index].id;
                      final orgData = [orgID, org];
                      return ListTile(
                        title: Text(org.name, style: const TextStyle(fontSize: 20, color: Colors.white), softWrap: true),
                        trailing: IconButton(
                          icon:  const Icon(Icons.account_circle_rounded, color: Colors.white, size: 30,),
                          onPressed: () {
                            showDialog(
                              context: context, 
                              builder: (BuildContext context) => createAlertDialog(context, org)
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, "/DonationDrivesPage", arguments: orgData);
                        },
                      );
                    }
                    ),
                  )
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget createAlertDialog(BuildContext context, Organization org) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      insetPadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.all(20),
      title: Text(org.name, style: const TextStyle(fontSize: 15, color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("          ${org.description}", style: const TextStyle(fontSize: 15, color: Colors.white)),
            const SizedBox(height: 10,),
            const Text("Address:", style: TextStyle(fontSize: 15, color: Colors.white)),
            for (var i = 0; i < org.address.length; i++)
              Text("    ${i+1}: ${org.address[i]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
            const SizedBox(height: 10,),
            Text("Phone Number: ${org.contactno}", style: const TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Back'),
          child: const Text('Back', style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
      ],
    );
  }

}