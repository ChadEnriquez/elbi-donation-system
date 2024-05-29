import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_app/model/donation.dart'; // Ensure you import your Donation model
import 'details/donations_detail.dart'; // Ensure you import your DonationDetailsPage

class ViewDonationsPage extends StatelessWidget {
  const ViewDonationsPage({Key? key}) : super(key: key); // Added constructor

  Future<List<Donation>> _fetchDonations() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('donations').get();
    return querySnapshot.docs.map((doc) => Donation.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donations List'),
      ),
      body: FutureBuilder<List<Donation>>(
        future: _fetchDonations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No donations found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final donation = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text('Donation ID: ${index + 1}'), // Change this to a suitable display format
                    subtitle: Text('Method: ${donation.method}'), // Example of displaying donation information
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonationDetailsPage(donation: donation),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
