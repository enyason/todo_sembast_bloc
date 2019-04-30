import 'package:equatable/equatable.dart';
import 'package:todo_sembast_bloc/model/todo.dart';

abstract class TodoStates extends Equatable{
  TodoStates([List props = const []]):super(props);
}

class LoadingTodoState extends TodoStates{}
class EmptyTodoState extends TodoStates{}
class LoadedTodoState extends TodoStates{

  List<Todo> list;

  LoadedTodoState(this.list):super([list]);


}