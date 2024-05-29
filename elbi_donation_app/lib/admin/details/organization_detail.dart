import 'package:elbi_donation_app/model/organization.dart';
import 'package:flutter/material.dart';

class OrganizationDetailsPage extends StatelessWidget {
  final Organization organization;

  const OrganizationDetailsPage({Key? key, required this.organization}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${organization.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${organization.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Address: ${organization.address.join(", ")}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Contact Number: ${organization.contactno}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            // Add more details here as needed
          ],
        ),
      ),
    );
  }
}
