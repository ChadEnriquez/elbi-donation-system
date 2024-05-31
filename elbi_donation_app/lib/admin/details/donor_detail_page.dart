import 'package:flutter/material.dart';
import 'package:elbi_donation_app/model/donor.dart';

class DonorDetailPage extends StatelessWidget {
  final Donor donor;

  const DonorDetailPage({Key? key, required this.donor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 177, 152, 1),
      appBar: AppBar(
        title: const Text(
          "Donor Details",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: const CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.grey,
                  child: CircleAvatar(
                    radius: 0,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  donor.name,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  donor.email,
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            buildUserInfoDisplay(donor.contactno, "Phone"),
            buildUserInfoDisplayArray(donor.address, "Address"),
            buildUserInfoDonations(context, donor), // Pass the context
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  Widget buildUserInfoDisplay(String getValue, String title) => Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(title,
              style: TextStyle(fontSize:17, color: Colors.black, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 1),
            Container(
                width: 350,
                height: 40,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ))),
                child: Row(children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getValue,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.black)),
                      ],
                    ),
                  ),
                ]))
          ],
        ),
      );

  Widget buildUserInfoDisplayArray(List<String> values, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(title,
              style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)
            ),
          const SizedBox(height: 1),
          Container(
            width: 350,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: Column(
              children: values.map((value) {
                return Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(value,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.black)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserInfoDonations(BuildContext context, Donor donor) => Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
                width: 350,
                height: 40,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ))),
                child: Row(children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Donations",
                            style: TextStyle(
                                fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/DonorDonationsPage', arguments: donor.donations);

                          },
                          icon: const Icon(
                            Icons.arrow_right_rounded,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ]))
          ],
        ),
      );
}
