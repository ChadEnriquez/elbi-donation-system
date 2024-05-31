
import 'package:elbi_donation_app/donor/donor_pages/donor_home_page.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:elbi_donation_app/organization/org_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elbi_donation_app/admin/admin_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<UserAuthProvider>().userStream;

    return StreamBuilder(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 53, 53, 53),
              body: Center(
                child: Text("Error encountered! ${snapshot.error}"),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor:  Color.fromARGB(255, 53, 53, 53),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (!snapshot.hasData) {
            // return const SignInPage();
          } return Scaffold(
            backgroundColor: const Color.fromARGB(255, 53, 53, 53),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:  ElevatedButton(
                      onPressed: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminHomePage()));
                      },
                      child: const Text("Admin")
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DonorHomePage()));
                      },
                      child: const Text("Donor")
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const OrgHomePage()));
                      },
                      child: const Text("Organization")
                    ),
                  ),
                ],
              ),
            )
          );
        }
      );
  }
}
