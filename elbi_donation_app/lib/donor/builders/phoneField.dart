import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneField extends StatefulWidget {
  final Function(PhoneNumber) callback;

  const PhoneField(this.callback, {super.key});

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'PH');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InternationalPhoneNumberInput(

          onInputChanged: (PhoneNumber number) {
            setState(() {
              _phoneNumber = number;
            });
            widget.callback(_phoneNumber);
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
          initialValue: _phoneNumber,
          inputDecoration: const InputDecoration(
            border: UnderlineInputBorder(),
            hintText: "Enter your Phone Number",
            labelStyle: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
            hintStyle: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
