import 'package:flutter/material.dart';

class DateAndTime extends StatefulWidget {
  final void Function(DateTime, TimeOfDay) callback;

  const DateAndTime({super.key, required this.callback});

  @override
  State<DateAndTime> createState() => _DateAndTimeState();
}

class _DateAndTimeState extends State<DateAndTime> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final hours = selectedTime.hour.toString().padLeft(2, '0');
    final minutes = selectedTime.minute.toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () async {
            final newDate = await pickDate(context);
            if (newDate == null) return;
            setState(() {
              selectedDate = newDate;
            });
            widget.callback(selectedDate, selectedTime);
          },
          child: Text("${selectedDate.year}/${selectedDate.month}/${selectedDate.day}", style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),
        ),
        ElevatedButton(
          onPressed: () async {
            final newTime = await pickTime(context);
            if (newTime == null) return;
            setState(() {
              selectedTime = newTime;
            });
            widget.callback(selectedDate, selectedTime);
          },
          child: Text("$hours:$minutes", style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }

  Future<DateTime?> pickDate(BuildContext context) {
    return showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: selectedDate,
      lastDate: DateTime(2025),
    );
  }

  Future<TimeOfDay?> pickTime(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
  }
}
