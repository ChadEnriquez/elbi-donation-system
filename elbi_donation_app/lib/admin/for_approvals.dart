// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ApprovalsPage extends StatefulWidget {
//   const ApprovalsPage({Key? key}) : super(key: key);

//   @override
//   _ApprovalsPageState createState() => _ApprovalsPageState();
// }

// class _ApprovalsPageState extends State<ApprovalsPage> {
//   late Stream<QuerySnapshot> _organizationsStream;

//   @override
//   void initState() {
//     super.initState();
//     // Load the organizations stream
//     _organizationsStream = FirebaseFirestore.instance.collection('organization').snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Approvals'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _organizationsStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }

//           final organizations = snapshot.data!.docs;

//           if (organizations.isEmpty) {
//             return Center(
//               child: Text('No organizations found.'),
//             );
//           }

//           return ListView.builder(
//             itemCount: organizations.length,
//             itemBuilder: (context, index) {
//               final organization = organizations[index];
//               return ListTile(
//                 title: Text(organization['name']),
//                 subtitle: Text('Email: ${organization['email']}'),
//                 trailing: Switch(
//                   value: organization['approval'],
//                   onChanged: (value) {
//                     _updateApprovalStatus(organization.reference, value);
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _updateApprovalStatus(DocumentReference organizationRef, bool newStatus) async {
//     try {
//       await organizationRef.update({'approval': newStatus});
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Approval status updated successfully.'),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update approval status: $e'),
//         ),
//       );
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    _organizationsStream = FirebaseFirestore.instance.collection('organization').where('approval', isEqualTo: false).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approvals'),
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
              return ListTile(
                title: Text(organization['name']),
                subtitle: Text('Email: ${organization['email']}'),
                trailing: Switch(
                  value: organization['approval'],
                  onChanged: (value) {
                    _updateApprovalStatus(organization.reference, value);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _updateApprovalStatus(DocumentReference organizationRef, bool newStatus) async {
    try {
      await organizationRef.update({'approval': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Approval status updated successfully.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update approval status: $e'),
        ),
      );
    }
  }
}
