import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/models/Todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem(
      {Key? key,
      required this.todo,
      required this.updateTodoCheck,
      required this.deleteTodo})
      : super(key: key);

  final Todo todo;
  final Function(Todo todo, bool ok) updateTodoCheck;
  final Function(Todo todo) deleteTodo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (e) {
                deleteTodo(todo);
              },
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Remover',
            ),
          ],
        ),
        child: CheckboxListTile(
          title: Text(todo.title),
          value: todo.ok,
          onChanged: (e) {
            if (e != null) {
              updateTodoCheck(todo, e);
            }
          },
          secondary: CircleAvatar(
            child: Icon(todo.ok ? Icons.check : Icons.error),
          ),
        ),
      ),
    );
  }
}
