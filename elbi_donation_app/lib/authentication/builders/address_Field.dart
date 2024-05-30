import 'package:flutter/material.dart';

class AddressTextField extends StatefulWidget {
  final Function(List<String>) callback;
  const AddressTextField({required this.callback, Key? key}) : super(key: key);
  @override
  State<AddressTextField> createState() => _AddressTextField();
}

class _AddressTextField extends State<AddressTextField> {
  List<String> _addresses = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < _addresses.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10), // Add vertical padding between rows
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      _addresses[i] = value;
                      widget.callback(_addresses);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      labelText: "Address",
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.home),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      _addresses.removeAt(i);
                      widget.callback(_addresses);
                    });
                  },
                ),
              ],
            ),
          ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _addresses.add("");
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(199, 177, 152, 1)), // Set button color to beige
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
              ),
            ),
          ),
          child: const Text("Add Address", style: TextStyle(fontSize: 15, color: Colors.black)),
        ),
        SizedBox(height: 20), // Add some additional space between the button and the address fields
      ],
    );
  }
}
