
import 'package:elbi_donation_app/admin/admin_home_page.dart';
import 'package:elbi_donation_app/authentication/signin_page.dart';
import 'package:elbi_donation_app/donor/donor_pages/donor_donation_details.dart';
import 'package:elbi_donation_app/donor/donor_pages/donor_donation_drives.dart';
import 'package:elbi_donation_app/donor/donor_pages/donor_donation_form.dart';
import 'package:elbi_donation_app/donor/donor_pages/donor_donation_page.dart';
import 'package:elbi_donation_app/donor/donor_pages/donor_home_page.dart';
import 'package:elbi_donation_app/donor/donor_pages/donor_profile.dart';
import 'package:elbi_donation_app/organization/org_home_page.dart';
import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:elbi_donation_app/provider/donation_provider.dart';
import 'package:elbi_donation_app/provider/donor_provider.dart';
import 'package:elbi_donation_app/provider/organization_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => UserAuthProvider())),
        ChangeNotifierProvider(create: ((context) => DonorProvider())),
        ChangeNotifierProvider(create: ((context) => DonationsProvider())),
        ChangeNotifierProvider(create: ((context) => OrganizationProvider()))
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elbi Donation System',
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInPage(), 
        '/donorhome': (context) => const DonorHomePage(),
        '/DonorProfile' : (context) => const DonorProfile(),
        '/orghome': (context) => const OrgHomePage(),
        '/adminhome': (context) => const AdminHomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/DonationDrivesPage') {
          final args = settings.arguments as List;
          return MaterialPageRoute(
            builder: (context) => DonationDrivesPage(orgData: args),
          );
        } else if (settings.name == '/DonorDonationForm') {
          final args = settings.arguments as List;
          return MaterialPageRoute(
            builder: (context) => DonorDonationForm(data: args),
          );
        } else if (settings.name == '/DonorDonationsPage') {
          final args = settings.arguments as List;
          return MaterialPageRoute(
            builder: (context) => DonorDonationPage(donationData: args),
          );
        } else if (settings.name == '/DonorDonationDetails') {
          final args = settings.arguments as List;
          return MaterialPageRoute(
            builder: (context) => DonorDonationDetails(donationData: args),
          );
        }
       return null;
      },
      theme: ThemeData.dark()
    );
  }
}
