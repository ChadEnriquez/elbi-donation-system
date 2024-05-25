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
        title: const Text( "Donor Profile", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding:const EdgeInsets.all(30),
              child: const CircleAvatar(
                radius: 75,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 0,
                ),
              ),
            ),
          ),
          buildUserInfoDisplay(donor.name, "Name"),
          buildUserInfoDisplay(donor.email, "Email"),
          buildUserInfoDisplay(donor.contactno, "Phone"),
          buildUserInfoDisplayArray(donor.address, "Address"),
        ],
      )
    );
  }

  Widget buildUserInfoDisplay(String getValue, String title) =>
    Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox( height: 20),
          Text(title),
          const SizedBox( height: 1,),
          Container(
            width: 350,
            height: 40,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey,width: 1,))
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Text(getValue, style: const TextStyle(fontSize: 15, color: Colors.white)),
                          IconButton(
                            onPressed: (){
                              // showDialog(context: context, 
                              //   builder: (BuildContext context) => createAlertDialog(context, person, personID, "name")
                              // );
                            }, 
                            icon: const Icon(Icons.create_rounded, color: Colors.white,)
                          )
                      ],
                    ),
                ),
              ]
            )
          )
        ],
      )
    );

  Widget buildUserInfoDisplayArray(List<String> values, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(title),
          const SizedBox(height: 1),
          Container(
            width: 350,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: Column(
              children: values.map((value) {
                return Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(value, style: const TextStyle(fontSize: 15, color: Colors.white)),
                            IconButton(
                              onPressed: () {
                                // showDialog(context: context, 
                                //   builder: (BuildContext context) => createAlertDialog(context, person, personID, "name")
                                // );
                              }, 
                              icon: const Icon(Icons.create_rounded, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

}
