class TodoData{
  String name;
  String dueDate;
  String dueTime;
  bool isComplete;

  TodoData({required this.name, required this.dueDate, required this.dueTime, this.isComplete = false});

  Map toMap(){
    return{
      'name' : this.name,
      'due_date' : this.dueDate,
      'due_time' : this.dueTime,
      'is_complete' : this.isComplete,
    };
  }

  TodoData.fromMap(Map map) :
      this.name = map['name'],
      this.dueDate = map['due_date'],
      this.dueTime = map['due_time'],
      this.isComplete = map['is_complete'];


}
