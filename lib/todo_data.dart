import 'package:flutter/material.dart';

class TodoData{
  String name;
  DateTime dueDate;
  TimeOfDay dueTime;
  bool isComplete = false;

  TodoData({required this.name, required this.dueDate, required this.dueTime});
}

List<TodoData> taskData = [];