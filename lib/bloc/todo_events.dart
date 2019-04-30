import 'package:equatable/equatable.dart';
import 'package:todo_sembast_bloc/model/todo.dart';

//base class for events
abstract class TodoEvents extends Equatable {
  TodoEvents([List props = const []]) : super(props);
}

class AddTodoEvent extends TodoEvents {

  final String task;

  AddTodoEvent(this.task):super([task]);


}

class DeleteTodoEvent extends TodoEvents {
  final Todo todo;

  DeleteTodoEvent(this.todo) : super([todo]);
}

class UpdateTodoEvent extends TodoEvents {
  final Todo todo;

  UpdateTodoEvent(this.todo) : super([todo]);
}

class QueryTodoEvent extends TodoEvents {

}

class TodoPageStartedEvent extends TodoEvents {

}
