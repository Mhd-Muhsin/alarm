import 'package:alarm/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/alarm_model.dart';
import '../provider/alarm_provider.dart';

class AlarmFormScreen extends StatefulWidget {
  final Alarm? alarm;

  const AlarmFormScreen({Key? key, this.alarm}) : super(key: key);

  @override
  _AlarmFormScreenState createState() => _AlarmFormScreenState();
}

class _AlarmFormScreenState extends State<AlarmFormScreen> {
  late TextEditingController _labelController;
  DateTime _selectedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(
      text: widget.alarm?.label ?? '',
    );
    _selectedTime = widget.alarm?.time ?? DateTime.now();
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  void _saveAlarm() {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);

    if (widget.alarm == null) {
      final newAlarm = Alarm(
        id: DateTime.now().millisecondsSinceEpoch ~/ 10000,
        time: _selectedTime,
        label: _labelController.text,
      );
      alarmProvider.addAlarm(newAlarm);
      scheduleAlarmNotification(newAlarm);
    } else {
      final updatedAlarm = Alarm(
        id: widget.alarm!.id,
        time: _selectedTime,
        label: _labelController.text,
      );
      alarmProvider.editAlarm(widget.alarm!.id, updatedAlarm);
      flutterLocalNotificationsPlugin.cancel(widget.alarm!.id);
      scheduleAlarmNotification(updatedAlarm);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alarm == null ? 'New Alarm' : 'Edit Alarm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(labelText: 'Label'),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: Text(
                'Time: ${_selectedTime.hour}:${_selectedTime.minute}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: _pickTime,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveAlarm,
              child: const Text('Save Alarm'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );

    if (timeOfDay != null) {
      setState(() {
        _selectedTime = DateTime(
          _selectedTime.year,
          _selectedTime.month,
          _selectedTime.day,
          timeOfDay.hour,
          timeOfDay.minute,
        );
      });
    }
  }
}
