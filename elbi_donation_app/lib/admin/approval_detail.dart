import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalDetailPage extends StatefulWidget {
  final DocumentSnapshot organization;

  const ApprovalDetailPage({Key? key, required this.organization}) : super(key: key);

  @override
  _ApprovalDetailPageState createState() => _ApprovalDetailPageState();
}

class _ApprovalDetailPageState extends State<ApprovalDetailPage> {
  late bool _approvalStatus;

  @override
  void initState() {
    super.initState();
    _approvalStatus = widget.organization['approval'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 177, 152, 1),
      appBar: AppBar(
        title: Text(
          widget.organization['name'],
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Proof of Legitimacy',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: widget.organization['proof'].isEmpty
                  ? const Text(
                      'No photo available',
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  : Image.network(widget.organization['proof']),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text(
                'Approval Status',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              value: _approvalStatus,
              onChanged: (value) {
                setState(() {
                  _approvalStatus = value;
                });
                _updateApprovalStatus(widget.organization.reference, value);
              },
              activeColor: Color.fromRGBO(199, 177, 152, 1),
            ),
          ],
        ),
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
