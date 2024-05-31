import 'package:elbi_donation_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key, this.text});
  final String? text;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      elevation: 1.5,
      shadowColor: Colors.grey[300],
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Color.fromRGBO(199, 177, 152, 1),
              ),
            child: Text("Main Menu", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold))),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, "/donorhome");
            },
            title: const Text("Homepage", style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, "/DonorProfile");
            },
            title: const Text("Profile", style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
          ListTile(
              title: Text('Logout', style: TextStyle(fontSize: 20),),
              onTap: () {
                context.read<UserAuthProvider>().signOut();
                Navigator.pushReplacementNamed(context, '/');
              }
          )
        ],
      ),
    );
  }
}