import 'details/organization_detail.dart';
import 'package:elbi_donation_app/model/organization.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewOrganizationsPage extends StatelessWidget {
  const ViewOrganizationsPage({Key? key}) : super(key: key); // Added constructor

  Future<List<Organization>> _fetchOrganizations() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('organization').get();
    return querySnapshot.docs.map((doc) => Organization.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 177, 152, 1),
      body: FutureBuilder<List<Organization>>(
        future: _fetchOrganizations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No organizations found'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  color: Color.fromRGBO(199, 177, 152, 1),
                  child: Center(
                    child: Text(
                      "List of Organizations",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded (
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final organization = snapshot.data![index];
                      return Card(
                        color: Colors.black,
                        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 40.0),
                        child: ListTile(
                          title: Text(organization.name),
                          subtitle: Text(organization.email),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => OrganizationDetailsPage(organization: organization),),);
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
