import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/donor/drawer.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:flutter/material.dart';

class DonorDonationPage extends StatefulWidget {
  final List donation;
  const DonorDonationPage({super.key, required this.donation});

  @override
  State<DonorDonationPage> createState() => _DonorDonationPageState();
}

class _DonorDonationPageState extends State<DonorDonationPage> {

  @override
  Widget build(BuildContext context) {
    List donations = widget.donation;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "Donations",
          style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("donations").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}", style: const TextStyle(fontSize: 30, color: Colors.white, fontStyle: FontStyle.italic),),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("Do Donations Yet", style: TextStyle(fontSize: 30, color: Colors.white, fontStyle: FontStyle.italic)),
            );
          } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: donations.length,
                      itemBuilder: ((context, index) {
                        final donation = Donation.fromJson(snapshot.data?.docs[index].data() as Map<String, dynamic>);
                        final donationID = snapshot.data?.docs[index].id;
                        if (donations.contains(donationID)) {
                          return ListTile(
                            title: Text(donationID!, style: const TextStyle(fontSize: 20, color: Colors.white), softWrap: true),
                            trailing: IconButton(
                                onPressed: () {
                                  // showDialog(
                                  //   context: context, 
                                  //   builder: (BuildContext context) => createAlertDialog(context, person, personID)
                                  //   );
                                },
                                icon: const Icon(Icons.delete_outlined, color: Colors.white),
                              ),
                              onTap: () {
                                // Navigator.pushNamed(context, "/Profile", arguments: personInfo); 
                              },
                              contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              hoverColor: Colors.blueGrey[800],
                          );
                        }
                        })
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: ElevatedButton(
                        onPressed: () async {
                            Navigator.pop(context);
                        }, 
                        child: const Text("Back", style: TextStyle(fontSize: 15, color: Colors.white)),
                        ),
                    ),
                  ]
                );
            }
          },
        ), 
    );
  }
}