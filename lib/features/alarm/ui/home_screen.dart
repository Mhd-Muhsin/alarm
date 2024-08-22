import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/alarm_provider.dart';
import 'alarm_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alarmProvider = Provider.of<AlarmProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
      ),
      body: ListView.builder(
        itemCount: alarmProvider.alarms.length,
        itemBuilder: (context, index) {
          final alarm = alarmProvider.alarms[index];
          return ListTile(
            title: Text(alarm.label),
            subtitle: Text('${alarm.time.hour}:${alarm.time.minute}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AlarmFormScreen(alarm: alarm),
                    ));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    alarmProvider.deleteAlarm(alarm.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AlarmFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
