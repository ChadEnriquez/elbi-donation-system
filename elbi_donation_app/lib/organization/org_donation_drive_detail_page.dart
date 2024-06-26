import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonationDriveDetailPage extends StatefulWidget {
  final String driveId;
  final String driveName;

  const DonationDriveDetailPage(
      {super.key, required this.driveId, required this.driveName});

  @override
  DonationDriveDetailPageState createState() => DonationDriveDetailPageState();
}

class DonationDriveDetailPageState extends State<DonationDriveDetailPage> {
  late String driveName;

  @override
  void initState() {
    super.initState();
    driveName = widget.driveName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 177, 152, 1),
      appBar: AppBar(
        title: Text(driveName, textAlign: TextAlign.center),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donation-drives')
            .doc(widget.driveId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || !snapshot.data!.exists) {
            return const Center(child: Text('Deleting data...'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final donationIDs = data['donationID'] as List<dynamic>;

          return ListView.builder(
            itemCount: donationIDs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(donationIDs[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final newDriveName = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  final controller = TextEditingController(text: driveName);
                  return AlertDialog(
                    backgroundColor: Colors.black,
                    title: const Text('Edit Donation Drive Name'),
                    content: TextField(
                      controller: controller,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Donation Drive Name',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Save'),
                        onPressed: () {
                          Navigator.of(context).pop(controller.text);
                        },
                      ),
                    ],
                  );
                },
              );

              if (newDriveName != null && newDriveName.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('donation-drives')
                    .doc(widget.driveId)
                    .update({'name': newDriveName});

                setState(() {
                  driveName = newDriveName;
                });
              }
            },
            heroTag: null,
            child: const Icon(Icons.edit),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () async {
              final confirmDelete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.black,
                    title: const Text('Confirm Delete'),
                    content: const Text(
                        'Are you sure you want to delete this donation drive?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); // User has cancelled the deletion
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(true); // User has confirmed the deletion
                        },
                      ),
                    ],
                  );
                },
              );

              if (confirmDelete == true) {
                await FirebaseFirestore.instance
                    .collection('donation-drives')
                    .doc(widget.driveId)
                    .delete();

                await Future.delayed(
                    const Duration(seconds: 1)); 

                Navigator.of(context).pop();
              }
            },
            heroTag: null,
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
