import 'dart:io';

import 'package:camera/camera.dart';
import 'package:elbi_donation_app/donor/drawer.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DonorDonationDetails extends StatefulWidget {
  final List donationData; 
  const DonorDonationDetails({super.key, required this.donationData});

  @override
  State<DonorDonationDetails> createState() => _DonorDonationDetailsState();
}

class _DonorDonationDetailsState extends State<DonorDonationDetails> {

  @override
  Widget build(BuildContext context) {
    final Donation donation = widget.donationData[0][1];
    final org = widget.donationData[1];
    final driveData = widget.donationData[2];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 53, 53),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "Donation Details",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Category: ${donation.category.join(', ')}",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Method: ${donation.method}",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Weight: ${donation.weight}",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Date: ${donation.date}",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Time: ${donation.time}",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 10),
            if (donation.method == "Pick-up") showForPickUp(donation),
            if (donation.photo != "") buttonPhoto(donation.photo),
            if (donation.qrImg != "") buttonQR(donation.qrImg),
            // showStatus(donation.status),
          ],
        ),
      ),
    );
  }

  Widget showForPickUp(Donation donation) {
    return Column(
      children: [
        Text("Address: ${donation.address.join(', ')}",style: const TextStyle(fontSize: 16, color: Colors.white),),
        const SizedBox(height: 10),
        Text("Phone: ${donation.phone}", style: const TextStyle(fontSize: 16, color: Colors.white),),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buttonPhoto(String photoUrl) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PhotoPreviewPage(photoUrl: photoUrl)));
          },
          child: const Text('Show Image', style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buttonQR(String qrUrl) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => QRPreviewPage(qrUrl: qrUrl)));
          },
          child: const Text('Show QR', style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

}

class PhotoPreviewPage extends StatelessWidget {
  const PhotoPreviewPage({super.key, required this.photoUrl});

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Preview')),
      body: Center(
        child: Image.network(photoUrl)
      ),
    );
  }
}

class QRPreviewPage extends StatelessWidget {
  const QRPreviewPage({super.key, required this.qrUrl});

  final String qrUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Preview')),
      body: Center(
        child: Image.network(qrUrl),
      ),
    );
  }
}
