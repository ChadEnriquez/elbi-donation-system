import 'package:flutter/material.dart';

class NumberInputField extends StatefulWidget {
  final Function(String) callback;
  const NumberInputField(this.callback, {super.key});

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  String _weight = "";

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      validator: (value) {
        if (_weight.isEmpty) return "Please enter the weight.";
        if (int.tryParse(_weight) == null) return "Please enter a valid weight.";
        return null;
      },
      onChanged: (value) {
        setState(() {
          _weight = value;
          widget.callback(_weight);
        });
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Enter Weight of donation",
        labelText: "Weight of Donation: ",
        labelStyle: TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}



class AddressTextField extends StatefulWidget {
  final Function(List<String>) callback;
  const AddressTextField({ required this.callback, super.key});
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
          Row(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: TextFormField(
                  onChanged: (value) {
                    _addresses[i] = value;
                    widget.callback(_addresses);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Address",
                    labelText: "Address: ",
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
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
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _addresses.add("");
            });
          },
          child: const Text("Add Address", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}