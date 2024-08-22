import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/alarm_model.dart';


class AlarmProvider with ChangeNotifier {
  List<Alarm> _alarms = [];

  List<Alarm> get alarms => _alarms;

  AlarmProvider() {
    loadAlarms();
  }

  void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
    saveAlarms();
    notifyListeners();
  }

  void editAlarm(int id, Alarm updatedAlarm) {
    final index = _alarms.indexWhere((alarm) => alarm.id == id);
    if (index != -1) {
      _alarms[index] = updatedAlarm;
      saveAlarms();
      notifyListeners();
    }
  }

  void deleteAlarm(int id) {
    _alarms.removeWhere((alarm) => alarm.id == id);
    saveAlarms();
    notifyListeners();
  }

  Future<void> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsData = prefs.getString('alarms') ?? '[]';
    final alarmsList = json.decode(alarmsData) as List;
    _alarms = alarmsList.map((alarm) => Alarm.fromMap(alarm)).toList();
    notifyListeners();
  }

  Future<void> saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsData = json.encode(_alarms.map((alarm) => alarm.toMap()).toList());
    prefs.setString('alarms', alarmsData);
  }
}
