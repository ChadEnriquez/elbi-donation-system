import 'package:flutter/material.dart';

class DonationForm extends StatefulWidget {
  const DonationForm({super.key});

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  // Define variables to store donor information
  List<String> categories = ['Food', 'Clothes', 'Cash', 'Necessities', 'Others'];
  late String selectedCategory;
  bool isForPickup = false;
  double weight = 0.0;
  late DateTime selectedDateTime;
  String address = '';
  String contactNo = '';

  // Method to handle date and time picker
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDateTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField(
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Donation Category'),
              ),
              Row(
                children: [
                  const Text('For Pickup:'),
                  Checkbox(
                    value: isForPickup,
                    onChanged: (value) {
                      setState(() {
                        isForPickup = value!;
                      });
                    },
                  ),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight (kg/lbs)'),
                onChanged: (value) {
                  setState(() {
                    weight = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () => _selectDateTime(context),
                child: Text(selectedDateTime != null
                    ? 'Selected Date: ${selectedDateTime.toString()}'
                    : 'Select Date and Time'),
              ),
              if (isForPickup)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Address'),
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                ),
              if (isForPickup)
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Contact No.'),
                  onChanged: (value) {
                    setState(() {
                      contactNo = value;
                    });
                  },
                ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
