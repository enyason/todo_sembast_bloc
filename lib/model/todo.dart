import 'package:meta/meta.dart';

class Todo {
  int id;
  String task;
  bool isDone;
  String timeStamp;

  Todo({@required this.task, @required this.isDone,@required this.timeStamp});

  Map<String, dynamic> toMap() {
    return {"task": task, "isDone": isDone,"timeStamp":timeStamp};
  }

  static Todo fromMap(Map<String, dynamic> map) {
    return Todo(task: map["task"], isDone: map["isDone"],timeStamp: map["timeStamp"]);
  }
}
