import 'package:dicoding_submission/my_drawer_widget.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _taskNameController = new TextEditingController();
  DateTime? _dueDate = null;
  static const String _dueDateStr = 'Due Date';
  TimeOfDay? _dueTime = null;
  static const String _dueTimeStr = 'Due Time';

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
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.menu_rounded,
            ),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            color: Colors.white,
            splashRadius: 20,
          ),
        ),
        drawer: MyDrawerWidget(),
        floatingActionButton: FloatingActionButton(
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
                            style: TextStyle(color: Colors.black, fontSize: 16),
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
                                child: Text(_dueTime == null
                                    ? _dueTimeStr
                                    : _dueTime!.format(context).toString()),
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
                                      TodoData todoData = new TodoData(
                                          name: _taskNameController.text
                                              .toString(),
                                          dueDate: _dueDate!,
                                          dueTime: _dueTime!);
                                      taskData.add(todoData);

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
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)))),
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
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 16),
                    child: Text(
                      'My Task',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                    )),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final TodoData todoData = taskData[index];
                    const Icon pendingTaskIcon =
                        Icon(Icons.circle_outlined, color: Colors.grey);
                    const Icon completeTaskIcon = Icon(
                      Icons.task_alt_rounded,
                      color: Colors.green,
                    );
                    return InkWell(
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
                                padding: EdgeInsets.fromLTRB(8, 16, 8,
                                    MediaQuery.of(context).viewInsets.bottom),
                                child: SingleChildScrollView(
                                    controller:
                                        ModalScrollController.of(context),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: SizedBox(
                                                width: 36,
                                                height: 5,
                                                child: const DecoratedBox(
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                Colors.grey)),
                                              )),
                                          Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  8, 8, 8, 16),
                                              child: Text(
                                                'Edit Task',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              )),
                                          TextField(
                                            controller: _taskNameController,
                                            textAlign: TextAlign.center,
                                            autofocus: true,
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                  ),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.all(8)),
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 8, top: 8),
                                              width: double.infinity,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  _pickDate(context);
                                                },
                                                child: Text(DateFormat.yMEd()
                                                    .format(_dueDate!)
                                                    .toString()),
                                                style: ButtonStyle(
                                                    padding: MaterialStateProperty
                                                        .all<EdgeInsets>(
                                                            EdgeInsets.all(14)),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(16)))),
                                              )),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 8),
                                              width: double.infinity,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  _pickTime(context);
                                                },
                                                child: Text(_dueTime!
                                                    .format(context)
                                                    .toString()),
                                                style: ButtonStyle(
                                                    padding: MaterialStateProperty
                                                        .all<EdgeInsets>(
                                                            EdgeInsets.all(14)),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(16)))),
                                              )),
                                          Container(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (_taskNameController
                                                              .text !=
                                                          null &&
                                                      _dueDate != null &&
                                                      _dueTime != null) {
                                                    setState(() {
                                                      todoData.name =
                                                          _taskNameController
                                                              .text
                                                              .toString();
                                                      todoData.dueDate =
                                                          _dueDate!;
                                                      todoData.dueTime =
                                                          _dueTime!;

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
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)))),
                                              )),
                                          Container(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Alert(
                                                        context: context,
                                                        style: AlertStyle(
                                                          animationType:
                                                              AnimationType
                                                                  .grow,
                                                          alertBorder: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .transparent)),
                                                          animationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      700),
                                                          isCloseButton: false,
                                                          titleStyle: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 24,
                                                              color:
                                                                  Colors.black),
                                                          descStyle: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14),
                                                        ),
                                                        title:
                                                            'Are You Sure To Delete Task ${_taskNameController.text.toString()}?',
                                                        desc:
                                                            'Deleted task can\'t be restored',
                                                        buttons: [
                                                          DialogButton(
                                                            child: Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            onPressed: () {
                                                              setState((){
                                                                taskData.remove(todoData);
                                                                Navigator.pop(context);
                                                                Navigator.pop(context);
                                                              });
                                                            },
                                                            radius: BorderRadius
                                                                .circular(16),
                                                            color: Colors.red,
                                                          ),
                                                          DialogButton(
                                                            child: Text(
                                                              'No',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            onPressed: () {
                                                              setState((){
                                                                Navigator.pop(context);
                                                              });
                                                            },
                                                            radius: BorderRadius
                                                                .circular(16),
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
                                                        MaterialStateProperty
                                                            .all((Colors.red)),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)))),
                                              )),
                                        ]))),
                          );
                        },
                        child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 8, 0),
                                        child: IconButton(
                                          splashRadius: 20,
                                          iconSize: 32,
                                          onPressed: () {
                                            setState(() {
                                              var tempTodoData = todoData;
                                              todoData.isComplete =
                                                  !todoData.isComplete;
                                              if (todoData.isComplete) {
                                                taskData.remove(todoData);
                                                taskData.add(tempTodoData);
                                              } else {
                                                taskData.remove(todoData);
                                                taskData.insert(
                                                    0, tempTodoData);
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              margin:
                                                  const EdgeInsets.only(top: 4),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              4, 0, 4, 0),
                                                      child: Text(
                                                        DateFormat.yMEd()
                                                            .format(todoData
                                                                .dueDate)
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      )),
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.grey,
                                                    size: 4,
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 4),
                                                      child: Text(
                                                        todoData.dueTime
                                                            .format(context)
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ))
                                                ],
                                              ))
                                        ],
                                      ))
                                    ]))));
                  },
                  itemCount: taskData.length,
                )),
              ],
            ),
          ),
        ));
  }
}
