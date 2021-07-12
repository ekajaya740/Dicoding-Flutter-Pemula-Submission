import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:dicoding_submission/todo_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TodoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoScreen();
}

class _TodoScreen extends State<TodoScreen> {
  String _listName = 'My Task';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> _animatedListKey =
      new GlobalKey<AnimatedListState>();
  TextEditingController _taskNameController = new TextEditingController();
  DateTime? _dueDate = null;
  static const String _dueDateStr = 'Due Date';
  TimeOfDay? _dueTime = null;
  static const String _dueTimeStr = 'Due Time';
  String taskName = '';
  List<TodoData> _taskData = [];

  final TextStyle _myTextFieldStyle =
      TextStyle(color: Colors.black, fontSize: 16);
  final InputDecoration _myTextFieldInputDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.all(8));
  final ButtonStyle _dueButtonStyle = ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(14)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              side: BorderSide(width: 1),
              borderRadius: BorderRadius.circular(16))));
  final ButtonStyle _saveButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))));

  final TextStyle _dateTimeFormatTextStyle =
      TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w300);

  final TextStyle _deleteConfirmationDescTextStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  final TextStyle _alertTitleStyle =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.black);

  Future<Null> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1945),
        lastDate: DateTime(2222));
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<Null> _pickTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _dueTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              _taskNameController.clear();
              _dueDate = null;
              _dueTime = null;
              showMaterialModalBottomSheet(
                backgroundColor: Colors.white,
                isDismissible: false,
                enableDrag: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(16),
                        topLeft: const Radius.circular(16))),
                context: context,
                builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(
                        8, 16, 8, MediaQuery.of(context).viewInsets.bottom),
                    child: SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                width: 36,
                                height: 5,
                                child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Colors.grey)),
                              )),
                          Container(
                              margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                              child: Text(
                                'Add Task',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )),
                          TextField(
                            controller: _taskNameController,
                            textCapitalization: TextCapitalization.sentences,
                            textAlign: TextAlign.center,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            style: _myTextFieldStyle,
                            decoration: InputDecoration(
                                hintText: 'Task Name',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(8)),
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 8, top: 8),
                              width: double.infinity,
                              child: OutlinedButton(
                                  onPressed: () {
                                    _pickDate(context);
                                  },
                                  child: Text(_dueDate == null
                                      ? _dueDateStr
                                      : DateFormat.yMEd()
                                          .format(_dueDate!)
                                          .toString()),
                                  style: _dueButtonStyle)),
                          Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  _pickTime(context);
                                },
                                child: Text(_dueTime == null
                                    ? _dueTimeStr
                                    : _dueTime!.format(context).toString()),
                                style: _dueButtonStyle,
                              )),
                          Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_taskNameController.text != null &&
                                      _dueDate != null &&
                                      _dueTime != null) {
                                    setState(() {
                                      TodoData todoData = new TodoData(
                                          name: _taskNameController.text
                                              .toString(),
                                          dueDate: _dueDate!,
                                          dueTime: _dueTime!);
                                      _taskData.add(todoData);
                                      _animatedListKey.currentState!.insertItem(
                                          _taskData.length - 1,
                                          duration: const Duration(
                                              milliseconds: 500));

                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: _saveButtonStyle,
                              ))
                        ]))),
              );
            },
            child: const Icon(
              Icons.add_rounded,
              size: 36,
              color: Color(0xFF212121),
            )),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(10, 16, 0, 16),
                    child: Text(
                      _listName,
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                    )),
                Expanded(
                    child: AnimatedList(
                  key: _animatedListKey,
                  physics: ScrollPhysics(),
                  initialItemCount: _taskData.length,
                  itemBuilder: (BuildContext context, int index,
                      Animation<double> animation) {
                    return _taskList(context, index, animation);
                  },
                )),
              ],
            ),
          ),
        ));
  }

  Widget _taskList(
      BuildContext context, int index, Animation<double> animation) {
    final TodoData todoData = _taskData[index];
    const Icon pendingTaskIcon =
        Icon(Icons.circle_outlined, color: Colors.grey);
    const Icon completeTaskIcon = Icon(
      Icons.task_alt_rounded,
      color: Colors.green,
    );
    return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset(0, 0),
        ).animate(animation),
        child: InkWell(
            onLongPress: () {
              _taskNameController.text = todoData.name;
              showMaterialModalBottomSheet(
                backgroundColor: Colors.white,
                enableDrag: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(16),
                        topLeft: const Radius.circular(16))),
                context: context,
                builder: (context) => Padding(
                    padding: EdgeInsets.fromLTRB(
                        8, 16, 8, MediaQuery.of(context).viewInsets.bottom),
                    child: SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                width: 36,
                                height: 5,
                                child: const DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Colors.grey)),
                              )),
                          Container(
                              margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                              child: Text(
                                'Edit Task',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )),
                          TextField(
                            controller: _taskNameController,
                            textAlign: TextAlign.center,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            style: _myTextFieldStyle,
                            decoration: _myTextFieldInputDecoration,
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 8, top: 8),
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  _pickDate(context);
                                },
                                child: Text(DateFormat.yMEd()
                                    .format(_dueDate!)
                                    .toString()),
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.all(14)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            side: BorderSide(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(16)))),
                              )),
                          Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  _pickTime(context);
                                },
                                child:
                                    Text(_dueTime!.format(context).toString()),
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.all(14)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            side: BorderSide(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(16)))),
                              )),
                          Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_taskNameController.text != null &&
                                      _dueDate != null &&
                                      _dueTime != null) {
                                    setState(() {
                                      todoData.name =
                                          _taskNameController.text.toString();
                                      todoData.dueDate = _dueDate!;
                                      todoData.dueTime = _dueTime!;

                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: _saveButtonStyle,
                              )),
                          Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Alert(
                                        context: context,
                                        style: AlertStyle(
                                          animationType: AnimationType.grow,
                                          alertBorder: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              side: BorderSide(
                                                  color: Colors.transparent)),
                                          animationDuration:
                                              Duration(milliseconds: 500),
                                          isCloseButton: false,
                                          titleStyle: _alertTitleStyle,
                                          descStyle:
                                              _deleteConfirmationDescTextStyle,
                                        ),
                                        title:
                                            'Delete task ${_taskNameController.text.toString()}?',
                                        desc: 'Deleted task can\'t be restored',
                                        buttons: [
                                          DialogButton(
                                            child: Text(
                                              'Yes',
                                              style:
                                                  _deleteConfirmationDescTextStyle,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _animatedListKey.currentState!
                                                    .removeItem(
                                                        index,
                                                        (context, animation) =>
                                                            _taskList(
                                                                context,
                                                                index,
                                                                animation),
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500));
                                                _taskData.remove(todoData);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              });
                                            },
                                            radius: BorderRadius.circular(16),
                                            color: Colors.red,
                                          ),
                                          DialogButton(
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                            radius: BorderRadius.circular(16),
                                            color: Colors.amber,
                                          )
                                        ]).show();
                                  });
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all((Colors.red)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)))),
                              )),
                        ]))),
              );
            },
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: IconButton(
                              splashRadius: 20,
                              iconSize: 32,
                              onPressed: () {
                                setState(() {
                                  var tempTodoData = todoData;
                                  todoData.isComplete = !todoData.isComplete;
                                  if (todoData.isComplete) {
                                    _taskData.remove(todoData);
                                    _taskData.add(tempTodoData);
                                  } else {
                                    _taskData.remove(todoData);
                                    _taskData.insert(0, tempTodoData);
                                  }
                                });
                              },
                              icon: todoData.isComplete == true
                                  ? completeTaskIcon
                                  : pendingTaskIcon,
                            ),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todoData.name,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.only(
                                              left: 4, top: 4),
                                          child: Text(
                                              DateFormat.yMEd()
                                                  .format(todoData.dueDate)
                                                  .toString(),
                                              style: _dateTimeFormatTextStyle)),
                                      Icon(
                                        Icons.circle,
                                        color: Colors.grey,
                                        size: 4,
                                      ),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 4),
                                          child: Text(
                                              todoData.dueTime
                                                  .format(context)
                                                  .toString(),
                                              style: _dateTimeFormatTextStyle))
                                    ],
                                  ))
                            ],
                          ))
                        ])))));
  }
}
