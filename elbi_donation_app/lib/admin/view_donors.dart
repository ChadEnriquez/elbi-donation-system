import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:elbi_donation_app/model/donor.dart';
import 'details/donor_detail_page.dart'; // Ensure you have the correct path to your DonorDetailPage file

class ViewDonorsPage extends StatelessWidget {
  const ViewDonorsPage({Key? key}) : super(key: key);

  Future<List<Donor>> _fetchDonors() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('donors').get();
    return querySnapshot.docs.map((doc) => Donor.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 177, 152, 1),
      body: FutureBuilder<List<Donor>>(
        future: _fetchDonors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No donors found'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  color: Color.fromRGBO(199, 177, 152, 1),
                  child: Center(
                    child: Text(
                      "List of Donors",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final donor = snapshot.data![index];
                      return Card(
                        color: Colors.black,
                        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                        child: ListTile(
                          title: Text(donor.name),
                          subtitle: Text(donor.email),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => DonorDetailPage(donor: donor),),);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
