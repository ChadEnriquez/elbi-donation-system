import 'package:elbi_donation_app/donor/donor_pages/donor_donation_details.dart';
import 'package:elbi_donation_app/model/organization.dart';
import 'package:flutter/material.dart';

class OrganizationDetailsPage extends StatelessWidget {
  final Organization organization;

  const OrganizationDetailsPage({Key? key, required this.organization}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoCard('Name', organization.name, context),
            buildInfoCard('Email', organization.email, context),
            buildInfoCard('Description', organization.description, context),
            buildInfoCard('Address', organization.address.join(", "), context),
            buildInfoCard('Contact Number', organization.contactno, context),
            SizedBox(height: 20),
            Center(
              child: Column (
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PhotoPreviewPage(photoUrl: organization.proof)),
                      );
                    },
                    icon: const Icon(Icons.image, size: 24),
                    label: const Text('Show Image', style: TextStyle(fontSize: 15, color:Colors.black)),
                  ),
                  const SizedBox(height: 20,),
                  statusButton(organization.approval),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String content, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width, // Set width to screen width
    child: Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget buttonPhoto(context, String photoUrl) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        icon: const Icon(Icons.image),
        label: const Text('Show Image', style: TextStyle(fontSize: 10)),
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => PhotoPreviewPage(photoUrl: photoUrl)),
          );
        },
      ),
    );
  }

  Widget statusButton(bool status) {
    switch (status) {
      case false:
        return Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: const Icon(Icons.cancel),
            label: const Text('Pending', style: TextStyle(fontSize: 15)),
            onPressed: () {}
          ),
        );
      case true:
        return Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: const Icon(Icons.cancel),
            label: const Text('Approved', style: TextStyle(fontSize: 15)),
            onPressed: () {},
          ),
        );
      default:
        return const Center();
    }
  }
}
