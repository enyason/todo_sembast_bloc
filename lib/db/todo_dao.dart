import 'dart:async';

import 'package:sembast/sembast.dart';
import 'package:todo_sembast_bloc/db/database.dart';
import 'package:todo_sembast_bloc/model/todo.dart';


class TodoDoa {
  static const String TODO_STORE_NAME = "todo_Store";

  final _todoStore = intMapStoreFactory.store(TODO_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Todo todo) async {
    await _todoStore.add(await _db, todo.toMap());
  }

  Future update(Todo todo) async{
    final finder = Finder(filter: Filter.byKey(todo.id));
    await _todoStore.update(await _db, todo.toMap(),finder: finder);
  }

  Future delete(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id));

    await _todoStore.delete(await _db, finder: finder);
  }

  Future<List<Todo>> getAllSortedByTImeStamp() async {
    final finder = Finder(sortOrders: [SortOrder("timeStamp",false)]);

    final snapshot = await _todoStore.find(
      await _db,
      finder: finder,
    );

    return snapshot.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);

      todo.id = snapshot.key;
      return todo;
    }).toList();
  }
}
