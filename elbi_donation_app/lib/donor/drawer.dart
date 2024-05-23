import 'package:flutter/material.dart';

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
      backgroundColor: const Color.fromARGB(255, 48, 48, 48),
      elevation: 1.5,
      shadowColor: Colors.grey[300],
      child: ListView(
        children: [
          const DrawerHeader(child: Text("Main Menu", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, "/");
            },
            title: const Text("Homepage", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, "/DonorProfile");
            },
            title: const Text("Profile", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}