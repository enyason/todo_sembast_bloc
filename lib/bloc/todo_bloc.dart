import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:todo_sembast_bloc/bloc/todo_events.dart';
import 'package:todo_sembast_bloc/bloc/todo_states.dart';
import 'package:todo_sembast_bloc/db/todo_dao.dart';
import 'package:todo_sembast_bloc/model/todo.dart';

class TodoBloc extends Bloc<TodoEvents, TodoStates> {
  final TodoDoa _todoDao;
  int tdlCount = 0;
  int isDoneCount=0;
  TodoBloc(this._todoDao);

  @override
  TodoStates get initialState => LoadingTodoState();

  @override
  Stream<TodoStates> mapEventToState(TodoEvents event) async* {

    if (event is AddTodoEvent) {

      //create new _todo object
      Todo todo = Todo(
          task: event.task.trim(),
          isDone: false,
          timeStamp: DateTime.now().millisecondsSinceEpoch.toString());

      //insert _todo to db
      await _todoDao.insert(todo);

      //query db to update ui
      dispatch(QueryTodoEvent());
//
    } else if (event is UpdateTodoEvent) {

      //update _todo
      await _todoDao.update(event.todo);

      //query db to update ui
      dispatch(QueryTodoEvent());

    } else if (event is DeleteTodoEvent) {

      //delete _todo
      await _todoDao.delete(event.todo);

      //query db to update ui
      dispatch(QueryTodoEvent());

    } else if (event is TodoPageStartedEvent) {
      //yield loading to show indicator
      yield LoadingTodoState();
    } else if (event is QueryTodoEvent) {

      //get
      final tdl = await _todoDao.getAllSortedByTImeStamp();

      // get count of _todo list items that are checked done
      isDoneCount=tdl.where((f)=>f.isDone).length;

      if (tdl.isEmpty) {

        //yield empty state if list is empty
        yield EmptyTodoState();
      } else {
        //keep track of list item
        tdlCount = tdl.length;

        //yield loaded state unto the stream with the list
        yield LoadedTodoState(tdl);


      }
    }
  }
}
