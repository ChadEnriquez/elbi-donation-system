
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/donor/drawer.dart';
import 'package:elbi_donation_app/model/donation.dart';
import 'package:elbi_donation_app/provider/donation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDonationDetails extends StatefulWidget {
  final List donationData; 
  const AdminDonationDetails({super.key, required this.donationData});

  @override
  State<AdminDonationDetails> createState() => _AdminDonationDetailsState();
}

class _AdminDonationDetailsState extends State<AdminDonationDetails> {

  @override
  Widget build(BuildContext context) {
    final donation = widget.donationData[0];
    final org = widget.donationData[1];
    final driveData = widget.donationData[2];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(199, 177, 152, 1),
      appBar: AppBar(
        title: const Text(
          "Donation Details",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoTile("Organization", org.name),
                  if (driveData != null) buildInfoTile("Donation Drive", driveData["name"]),
                  buildInfoTile("Category", donation.category.join(', ')),
                  buildInfoTile("Method", donation.method),
                  buildInfoTile("Weight", donation.weight.toString()),
                  buildInfoTile("Date", donation.date),
                  buildInfoTile("Time", donation.time),
                  if (donation.method == "Pick-up") showForPickUp(donation),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buttonPhoto(donation.photo),
                      buttonQR(donation.qrImg),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  statusButton(donation.status),
                ],
              ),
          )
    );
  }

  Widget buildInfoTile(String title, String value) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget statusButton(String status) {
    switch (status) {
      case "Pending":
        return Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: const Icon(Icons.cancel),
            label: const Text('Cancel Donation', style: TextStyle(fontSize: 15)),
            onPressed: () {}
          ),
        );
      case "Cancelled":
        return Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: const Icon(Icons.cancel),
            label: const Text('Donation Cancelled', style: TextStyle(fontSize: 15)),
            onPressed: null,
          ),
        );
      case "Confirmed":
        return Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: const Icon(Icons.check_circle),
            label: const Text('Confirmed', style: TextStyle(fontSize: 15)),
            onPressed: () {},
          ),
        );
      case "Scheduled for Pick-up":
        return Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: const Icon(Icons.schedule),
            label: const Text('Scheduled for Pick-up', style: TextStyle(fontSize: 15)),
            onPressed: () {},
          ),
        );
      case "Complete":
        return Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: const Icon(Icons.done),
            label: const Text('Complete', style: TextStyle(fontSize: 15)),
            onPressed: () {},
          ),
        );
      default:
        return Center(
          child: Text(
            status,
            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      }
    }


  Widget showForPickUp(Donation donation) {
    return Column(
      children: [
        buildInfoTile("Address", donation.address.join(', ')),
        buildInfoTile("Phone", donation.phone),
      ],
    );
  }

  Widget buttonPhoto(String photoUrl) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        icon: const Icon(Icons.image),
        label: const Text('Show Image', style: TextStyle(fontSize: 15)),
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => PhotoPreviewPage(photoUrl: photoUrl)),
          );
        },
      ),
    );
  }

  Widget buttonQR(String qrUrl) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        icon: const Icon(Icons.qr_code),
        label: const Text('Show QR', style: TextStyle(fontSize: 15)),
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => QRPreviewPage(qrUrl: qrUrl)),
          );
        },
      ),
    );
  }
}

class PhotoPreviewPage extends StatelessWidget {
  const PhotoPreviewPage({super.key, required this.photoUrl});

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Preview',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.black,
              shadowColor: Colors.grey[300],
              iconTheme: const IconThemeData(color: Colors.white),
          ),
      body: Center(
        child: photoUrl.isEmpty ? const Text("No photo available", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),) : Image.network(photoUrl),
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
        child: qrUrl.isEmpty ? const Text("No photo available") : Image.network(qrUrl)
      ),
    );
  }
}
