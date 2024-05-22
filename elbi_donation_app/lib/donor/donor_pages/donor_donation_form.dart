import 'package:elbi_donation_app/donor/builders/checkbox.dart';
import 'package:elbi_donation_app/donor/builders/dateandtime.dart';
import 'package:elbi_donation_app/donor/builders/phoneField.dart';
import 'package:elbi_donation_app/donor/builders/radiobutton.dart';
import 'package:elbi_donation_app/donor/builders/textfeilds.dart';
import 'package:elbi_donation_app/donor/drawer.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:elbi_donation_app/model/organization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class DonorDonationForm extends StatefulWidget {
  final List orgData; 
  const DonorDonationForm({super.key, required this.orgData});

  @override
  State<DonorDonationForm> createState() => _DonorDonationFormState();
}

class _DonorDonationFormState extends State<DonorDonationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var information = <dynamic, dynamic> {
    "category": [],
    "donationmethod": "Drop-off",
    "weight": "",
    "photo": "",
    "date": "",
    "time": "",
    "address": [],
    "phone": "",
    "status": "",
    "orgID" : "",
  };

  @override
  Widget build(BuildContext context) {
    String orgID = widget.orgData[0];
    Organization org = widget.orgData[1];
    return Scaffold(
       backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text( org.name, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon:  const Icon(Icons.account_circle_rounded, color: Colors.white, size: 30,),
            onPressed: () {
              showDialog(
                context: context, 
                builder: (BuildContext context) => createAlertDialogProfile(context, org)
              );
            },
          ),
        ]
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin:  const EdgeInsets.fromLTRB(30, 5, 30, 5),
                padding: const EdgeInsets.all(10),
                child: const Text("DONATION FORM", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border( top: BorderSide(width: 2, color: Colors.white)),
                ),
                child: Column (
                  children: [
                    const SizedBox(height: 10),
                    const Text("Type of Donation", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                    CheckboxCategory(callback: (selectedCategories) => setState(() => information["category"] = selectedCategories)),
                  ],
                )
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border( top: BorderSide(width: 2, color: Colors.white)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text("Weight", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    NumberInputField((String weight) {setState(() {information["weight"] = weight;});}),
                    const SizedBox(height: 10),
                  ]
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border( top: BorderSide(width: 2, color: Colors.white)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text("Date and Time", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    DateAndTime(callback: (selectedDate, selectedTime) => setState(() {
                      information["date"] = selectedDate;
                      information["time"] = selectedTime;
                    })),
                    const SizedBox(height: 10),
                  ]
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border( top: BorderSide(width: 2, color: Colors.white), bottom: BorderSide(width: 2, color: Colors.white)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text("Pick-up or Drop-off", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    RadiotButton(initValue: information["donationmethod"], callback: (initValue){setState(() {information["donationmethod"] = initValue;});},),
                    const SizedBox(height: 10),
                  ]
                ),
              ),
              if (information["donationmethod"] == "Pick-up")
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border( bottom: BorderSide(width: 2, color: Colors.white)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text("Phone Number", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      PhoneField((PhoneNumber phone) {setState(() {information["phone"] = phone.phoneNumber as String;});}),
                      const SizedBox(height: 10),
                    ]
                  ),
                ),
              if (information["donationmethod"] == "Pick-up")
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border( bottom: BorderSide(width: 2, color: Colors.white)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text("Address", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      AddressTextField(callback: (addresses) => setState(() => information["address"] = addresses)),
                      const SizedBox(height: 10),
                    ]
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container( //SUBMIT BUTTON
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 30 ),
                    child: ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Donation donation = Donation(
                            category: information["category"], 
                            method: information["donationmethod"], 
                            weight: information["weight"], 
                            photo: information["photo"], 
                            date: information["date"], 
                            time: information["time"], 
                            address: information["address"], 
                            phone: information["phone"], 
                            status: "Pending", 
                            orgID: orgID);
                          // context.read<SlambookProvider>().addFriend(person);
                          showDialog(
                            context: context, 
                            builder: (BuildContext context) => createAlertDialogForm(context)
                          );
                        }
                      }, 
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent), 
                        ),
                      child: const Text("SUBMIT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    ),
                  ),
                  Container( //RESET BUTTON
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                    child: ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                        setState(() {
                            information["category"] = [];
                            information["donationmethod"] = "Pick-up";
                            information["weight"] = "";
                            information["photo"] = "";
                            information["date"] = "";
                            information["time"] = "";
                            information["address"] = [];
                            information["phone"] = "";
                            information["status"] = "";
                            information["orgID"] = "";
                        });
                      }, 
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent), 
                        ),
                      child: const Text("RESET", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ],
          ), 
        ),
      )
    );
  }

  Widget createAlertDialogProfile(BuildContext context, Organization org) {
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
            const Text("Address:", style: TextStyle(fontSize: 15, color: Colors.white)),
            for (var i = 0; i < org.address.length; i++)
              Text("    ${i+1}: ${org.address[i]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
            Text("Phone Number: ${org.phone}", style: const TextStyle(fontSize: 15, color: Colors.white)),
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

  Widget createAlertDialogForm(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      insetPadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.all(20),
      title: const Text("Donation Details", style: TextStyle(fontSize: 15, color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Category: ${information["category"]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
            Text("Method: ${information["donationmethod"]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
            Text("Weight: ${information["weight"]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
            Text("Date: ${information["date"]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
            Text("Time: ${information["time"]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
            const Text("Address:", style: TextStyle(fontSize: 15, color: Colors.white)),
            for (var i = 0; i < information["address"].length; i++)
              Text("  ${i + 1}: ${information["address"][i]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
            Text("Phone Number: ${information["phone"]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
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