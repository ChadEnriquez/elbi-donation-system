import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'approval_detail.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({Key? key}) : super(key: key);

  @override
  _ApprovalsPageState createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> {
  late Stream<QuerySnapshot> _organizationsStream;

  @override
  void initState() {
    super.initState();
    // Load the organizations stream with organizations where approval is false
    _organizationsStream = FirebaseFirestore.instance
        .collection('organization')
        .where('approval', isEqualTo: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 177, 152, 1),
      appBar: AppBar(
        title: Text(
          'Approvals',
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        shadowColor: Colors.grey[300],
        iconTheme:
            const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _organizationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final organizations = snapshot.data!.docs;

          if (organizations.isEmpty) {
            return Center(
              child: Text('No organizations found.'),
            );
          }

          return ListView.builder(
            itemCount: organizations.length,
            itemBuilder: (context, index) {
              final organization = organizations[index];
              return Card(
                color: Colors.black,
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    organization['name'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    organization['email'],
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ApprovalDetailPage(organization: organization),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
