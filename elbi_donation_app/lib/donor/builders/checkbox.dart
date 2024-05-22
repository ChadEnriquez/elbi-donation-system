import 'package:flutter/material.dart';

class CheckboxCategory extends StatefulWidget {
  final Function(List<String>) callback;
  const CheckboxCategory({required this.callback, super.key});

  @override
  State<CheckboxCategory> createState() => _CheckboxCategoryState();
}

class _CheckboxCategoryState extends State<CheckboxCategory> {
  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  bool checkboxValue4 = false;
  bool checkboxValue5 = false;

  void _onCheckboxChanged(bool? value, int index) {
    setState(() {
      switch (index) {
        case 1:
          checkboxValue1 = value!;
          break;
        case 2:
          checkboxValue2 = value!;
          break;
        case 3:
          checkboxValue3 = value!;
          break;
        case 4:
          checkboxValue4 = value!;
          break;
        case 5:
          checkboxValue5 = value!;
          break;
      }
    });
    _notifyParent();
  }

  void _notifyParent() {
    List<String> selectedCategories = [];
    if (checkboxValue1) selectedCategories.add('Food');
    if (checkboxValue2) selectedCategories.add('Clothes');
    if (checkboxValue3) selectedCategories.add('Medicine');
    if (checkboxValue4) selectedCategories.add('Cash');
    if (checkboxValue5) selectedCategories.add('Others');
    widget.callback(selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CheckboxListTile(
          value: checkboxValue1,
          onChanged: (bool? value) {
            _onCheckboxChanged(value, 1);
          },
          side: const BorderSide(color: Colors.white),
          title: const Text('Food', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        CheckboxListTile(
          value: checkboxValue2,
          onChanged: (bool? value) {
            _onCheckboxChanged(value, 2);
          },
          side: const BorderSide(color: Colors.white),
          title: const Text('Clothes', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        CheckboxListTile(
          value: checkboxValue3,
          onChanged: (bool? value) {
            _onCheckboxChanged(value, 3);
          },
          side: const BorderSide(color: Colors.white),
          title: const Text('Medicine', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        CheckboxListTile(
          value: checkboxValue4,
          onChanged: (bool? value) {
            _onCheckboxChanged(value, 4);
          },
          side: const BorderSide(color: Colors.white),
          title: const Text('Cash', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        CheckboxListTile(
          value: checkboxValue5,
          onChanged: (bool? value) {
            _onCheckboxChanged(value, 5);
          },
          side: const BorderSide(color: Colors.white),
          title: const Text('Others', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
