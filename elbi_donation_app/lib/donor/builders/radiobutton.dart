import 'package:flutter/material.dart';

class RadiotButton extends StatefulWidget {
  final Function(String) callback;
  final String initValue;
  const RadiotButton({required this.initValue, required this.callback, super.key});

  @override
  State<RadiotButton> createState() => _RadiotButtonState();
}

class _RadiotButtonState extends State<RadiotButton> {
  late String? _pick;

  @override
  void initState() {
    super.initState();
    _pick = widget.initValue;
  }

  static final List<String> _method = [
    "Drop-off",
    "Pick-up"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < _method.length; i++)
          ListTile(
            title: Text(_method[i]),
            textColor: Colors.white,
            leading: Radio<String>(
              value: _method[i],
              groupValue: _pick,
              onChanged: (String? value) {
                setState(() {
                  _pick = value;
                });
                widget.callback(value!);
              },
            ),
          ),
      ],
    );
  } 
}