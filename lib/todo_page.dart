import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_sembast_bloc/bloc/todo_bloc.dart';
import 'package:todo_sembast_bloc/bloc/todo_events.dart';
import 'package:todo_sembast_bloc/bloc/todo_states.dart';
import 'package:todo_sembast_bloc/model/todo.dart';
import 'package:todo_sembast_bloc/db/todo_dao.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {

  TodoBloc _todoBloc; //bloc
  TextEditingController _textEditingController; // controller for text field

  @override
  void initState() {
    // create instance of the class member variables
    _textEditingController = TextEditingController();
    _todoBloc = TodoBloc(TodoDoa());

    //dispatch query event to retrieve _todo list
    _todoBloc.dispatch(QueryTodoEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("TDL"),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _textEditingController.text = "";
          _asyncInputDialog(context, null);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {

    // bloc builder acts like a s
    return BlocBuilder(bloc: _todoBloc, builder:(context, state){



      print(state);
      //show indicator if state is loading
      if (state is LoadingTodoState) {
        return Center(
            child: Container(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator()));
      }

      //if state is empty show empty msg
      if (state is EmptyTodoState) {
        return Center(child: Text("Todo list is empty"));
      }

      if (state is LoadedTodoState) {

        //if state is empty show empty msg

        if (state.list.length == 0 || state.list == null) {
          return Center(
            child: Text("Todo list is empty"),
          );
        }

        //get percent
        var percent = ((_todoBloc.isDoneCount / _todoBloc.tdlCount) * 100);

        //get current date
        var format = DateFormat("yMMMMd");
        var dateString = format.format(DateTime.now());

        //if state is loaded. display items in a list

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 8.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.today,
                    color: Colors.blue,
                  ),
                  Text(dateString)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 40.0, bottom: 8.0, top: 8.0, right: 8.0),
              child: Text(
                "${_todoBloc.tdlCount} Task",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25.0, left: 40.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 2.0,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[400],
                        value: (percent / 100),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text("${percent.floor()}%")
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
//                      reverse: true,
                  shrinkWrap: true,
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    return _buildListTile(state.list[index]);
                  }),
            )
          ],
        );
      }




    });



  }

  Widget _buildListTile(Todo todo) {
    return ListTile(
      title: todo.isDone
          ? Text(
        todo.task,
        style: TextStyle(
            decoration: TextDecoration.lineThrough,
            decorationColor: Colors.blue,
            color: Colors.blue),
      )
          : Text(todo.task),
      leading: todo.isDone
          ? Icon(
        Icons.check_circle_outline,
        color: Colors.blue,
      )
          : Icon(Icons.radio_button_unchecked),
      trailing: IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () {
            //delete item
            _todoBloc.dispatch(DeleteTodoEvent(todo));
          }),
      onTap: () {
        _asyncInputDialog(context, todo);
      },
      onLongPress: () {
        //toggle task state
        if (todo.isDone) {
          todo.isDone = false;
        } else {
          todo.isDone = true;
        }

        //update item
        _todoBloc.dispatch(UpdateTodoEvent(todo));
      },
    );
  }

  //dialog to make update to item
  Future _asyncInputDialog(BuildContext context, Todo todo) async {
    String task = "";

    //if item is not null, set task and controller text to _todo value
    if (todo != null) {
      task = todo.task;
      _textEditingController.text = todo.task;
    }

    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('What are you planning to perform?'),
          content: Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        labelText: 'New Task', hintText: "Your Task"),
                    onChanged: (value) {
                      task = value;
                    },
                  ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              //render child depending on the sate of the todo
              child: todo == null ? Text('Create task') : Text("Update task"),
              onPressed: () {
                //handle empty state for input field
                if (task.trim().length < 1) {
                  Toast.show("failed!", context,
                      duration: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.black);
                  return;
                }

                //dispatch event depending on the state
                if (todo == null) {
                  _todoBloc.dispatch(AddTodoEvent(task));
                } else {
                  todo.task = task;
                  _todoBloc.dispatch(UpdateTodoEvent(todo));
                }

                //close dialog window
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
