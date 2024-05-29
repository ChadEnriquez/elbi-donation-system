import 'package:flutter/material.dart';
import 'package:elbi_donation_app/model/donation.dart'; // Ensure you import your Donation model

class DonationDetailsPage extends StatelessWidget {
  final Donation donation;

  const DonationDetailsPage({Key? key, required this.donation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Method: ${donation.method}'),
            Text('Weight: ${donation.weight}'),
            Text('Date: ${donation.date}'),
            Text('Time: ${donation.time}'),
            Text('Address: ${donation.address.join(', ')}'),
            Text('Phone: ${donation.phone}'),
            Text('Status: ${donation.status}'),
            Text('Organization ID: ${donation.orgID}'),
            Text('Donation Drive ID: ${donation.donationDriveID}'),
            Text('Donor ID: ${donation.donorID}'),
          ],
        ),
      ),
    );
  }
}
