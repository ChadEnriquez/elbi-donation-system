import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:elbi_donation_app/donor/builders/camera.dart';
import 'package:elbi_donation_app/donor/builders/checkbox.dart';
import 'package:elbi_donation_app/donor/builders/dateandtime.dart';
import 'package:elbi_donation_app/donor/builders/phoneField.dart';
import 'package:elbi_donation_app/donor/builders/radiobutton.dart';
import 'package:elbi_donation_app/donor/builders/textfeilds.dart';
import 'package:elbi_donation_app/donor/drawer.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:elbi_donation_app/model/donor.dart';
import 'package:elbi_donation_app/model/organization.dart';
import 'package:elbi_donation_app/provider/donation_provider.dart';
import 'package:elbi_donation_app/provider/donor_provider.dart';
import 'package:elbi_donation_app/provider/organization_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';


class DonorDonationForm extends StatefulWidget {
  final List data; 
  const DonorDonationForm({super.key, required this.data});

  @override
  State<DonorDonationForm> createState() => _DonorDonationFormState();
}

class _DonorDonationFormState extends State<DonorDonationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  var information = <dynamic, dynamic> {
    "category": <String>[],
    "donationmethod": "Drop-off",
    "weight": "",
    "photo": "",
    "date": DateTime.now(),
    "time": TimeOfDay.now(),
    "address": <String>[],
    "contactno": "",
    "status": "",
    "orgID" : "",
    "donationDriveID" : "",
    "qrImg": ""
  };

  @override
  Widget build(BuildContext context) {
    List<dynamic> donorData = context.read<DonorProvider>().donor; 
    String donorID = donorData[0];
    Donor donor = donorData[1]; 

    String orgID = "";
    String driveID = "";
    var data = widget.data[1];

    if (widget.data[1] is Organization){
      orgID = widget.data[0];
      data = widget.data[1];
      driveID = "";
    } else {
      driveID = widget.data[0];
      data = widget.data[1];
      orgID = data.organizationID;
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text(data.name, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
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
                    const Text("Weight of Donation in KILOGRAM (kg)", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
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
                      PhoneField((PhoneNumber phone) {setState(() {information["contactno"] = phone.phoneNumber as String;});}),
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
              Center(
                  child: ElevatedButton(
                  onPressed: () async {
                    await availableCameras().then((value) => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => CameraPage(callback:(imageFile) {setState(() => information["photo"] = imageFile);}, cameras: value))
                      )
                    );
                  },
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 30,),
                )
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container( //SUBMIT BUTTON
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 30 ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if(_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          String formattedDate = "${information["date"].year}-${information["date"].month.toString().padLeft(2, '0')}-${information["date"].day.toString().padLeft(2, '0')}";
                          String formattedTime = "${information["time"].hour.toString().padLeft(2, '0')}:${information["time"].minute.toString().padLeft(2, '0')} ${information["time"].period == DayPeriod.am ? "AM" : "PM"}";

                          Donation donation = Donation(
                            category: information["category"], 
                            method: information["donationmethod"], 
                            weight: information["weight"], 
                            photo: "", 
                            date: formattedDate, 
                            time: formattedTime, 
                            address: information["address"] ?? "", 
                            phone: information["phone"] ?? "", 
                            status: "Pending", 
                            orgID: orgID,
                            donationDriveID: driveID,
                            donorID: donorID,
                            qrImg: ""
                          );
                          String donationID =  await context.read<DonationsProvider>().addDonation(donation);
                          donor.donations.add(donationID);
                          context.read<DonorProvider>().addDonation(donorID,donor.donations);
                          context.read<OrganizationProvider>().addDonation(orgID, donor.donations);
                          showDialog(
                            context: context, 
                            builder: (BuildContext context) => createAlertDialogForm(context, donationID, donorID)
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

                            information["category"] = <String>[];
                            information["donationmethod"] = "Drop-off";
                            information["weight"] = "";
                            information["photo"] = "";
                            information["date"] = DateTime.now();
                            information["time"] = TimeOfDay.now();
                            information["address"] = <String>[];
                            information["contactno"] = "";
                            information["status"] = "";
                            information["orgID"] = "";
                            information["donorID"] = "";
                            information["donationDriveID"] = "";
                            information["qrImg"] = "";
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

  Widget createAlertDialogForm(BuildContext context, String donationID, String donorID) {
    String formattedDate = "${information["date"].year}-${information["date"].month.toString().padLeft(2, '0')}-${information["date"].day.toString().padLeft(2, '0')}";
    String formattedTime = "${information["time"].hour.toString().padLeft(2, '0')}:${information["time"].minute.toString().padLeft(2, '0')} ${information["time"].period == DayPeriod.am ? "AM" : "PM"}";

    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      insetPadding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.all(20),
      title: const Text("Donation Details", style: TextStyle(fontSize: 15, color: Colors.white)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Category:", style: TextStyle(fontSize: 15, color: Colors.white)),
              for (var i = 0; i < information["category"].length; i++)
                Text("  ${i + 1}: ${information["category"][i]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
              Text("Method: ${information["donationmethod"]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
              Text("Weight: ${information["weight"]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
              Text("Date: $formattedDate", style: const TextStyle(fontSize: 15, color: Colors.white)),
              Text("Time: $formattedTime", style: const TextStyle(fontSize: 15, color: Colors.white)),
              if (information["donationmethod"] == "Pick-up") showForPickUp(),
              if (information["donationmethod"] == "Drop-off") generateQRcode(donationID),
              if (information["photo"] != "") showPhoto(context, donationID, donorID),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            if (information["donationmethod"] == "Drop-off") {
              await _saveQRImage(donationID);
            }
            if (information["photo"] != "") {
              String? photoURL = await context.read<DonationsProvider>().addDonationPhoto(information["photo"],donationID);
              print("Photo URL: $photoURL");
              context.read<DonationsProvider>().editDonationPhoto(donationID, photoURL);
            }
            setState(() {
              information["category"] = <String>[];
              information["donationmethod"] = "Drop-off";
              information["weight"] = "";
              information["photo"] = "";
              information["date"] = "";
              information["time"] = "";
              information["address"] = <String>[];
              information["contactno"] = "";
              information["status"] = "";
              information["orgID"] = "";
              information["donorID"] = "";
              information["donationDriveID"] = "";
              information["qrImg"] = "";
            });
            Navigator.pop(context, 'Back');
          },
          child: const Text('Back', style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
      ],
    );
  }

  Widget showForPickUp() {
    return Column(
      children: [
        const Text("Address: ", style: TextStyle(fontSize: 15, color: Colors.white)),
        for (var i = 0; i < information["address"].length; i++)
          Text("${i + 1}: ${information["address"][i]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
        Text("Phone Number: ${information["contactno"]}", style: const TextStyle(fontSize: 15, color: Colors.white)),
      ],
    );
  }

  Widget generateQRcode(String donationID) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.white, // Set background color
          padding: const EdgeInsets.all(5), // Adjust padding if needed
          child: RepaintBoundary(
                key: _repaintBoundaryKey,
                child: QrImageView(
                  data: donationID,
                  version: QrVersions.auto,
                  size: 100,
                  gapless: false,
                ),
              )
          ),
      ],
    );
  }

  Future<String?> _saveQRImage(String donationID) async {
    try {
      if (_repaintBoundaryKey.currentContext != null) {
        RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage(pixelRatio: 3.0);
        // Drawing white background because QR code is black
        final whitePaint = Paint()..color = Colors.white;
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
        canvas.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), whitePaint);
        canvas.drawImage(image, Offset.zero, Paint());
        final picture = recorder.endRecording();
        final img = await picture.toImage(image.width, image.height);
        ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
        Uint8List imageData = byteData!.buffer.asUint8List();

        // Save Uint8List to a temporary file
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/${donationID}_QR.png').create();
        await file.writeAsBytes(imageData);

        // Convert the temporary file to an XFile
        final XFile imageXFile = XFile(file.path);

        // Upload QR image to storage
        String? downloadURL = await context.read<DonationsProvider>().addQRimg(imageXFile, donationID);
        // Add image link from storage to the instance of donation in firebase 
        context.read<DonationsProvider>().editQRimg(donationID, downloadURL);
        return downloadURL.toString();
      }
    } catch (e) {
      print('Error saving QR code image: $e');
      return "Error";
    }
    return null;
  }

  Widget showPhoto(BuildContext context, String donationID, String donorID) {
    return TextButton(
      onPressed: () {
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => PreviewPage(picture: information["photo"]))
        );
      },
      child: const Text('Show Image', style: TextStyle(fontSize: 15, color: Colors.white)),
    );
  }

}