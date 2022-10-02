import 'package:flutter/material.dart';
import 'package:todo_list/models/Todo.dart';
import 'package:todo_list/pages/widgets/todo_list_item.dart';
import 'package:todo_list/repositories/todo_repository.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  void addTodo() {
    if (todoController.text.isEmpty) {
      errorText = 'Campo obrigatório';
      return;
    }

    setState(() {
      todos.add(Todo(title: todoController.text));
    });

    todoController.clear();
    todoRepository.saveTodoList(todos);
    errorText = null;
  }

  void updateTodoCheck(Todo todo, bool ok) {
    final int todoIndex = todos.indexOf(todo);

    setState(() {
      todos[todoIndex].ok = ok;
    });

    todoRepository.saveTodoList(todos);
  }

  void deleteTodo(Todo todo) {
    int todoIndex = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} removida.',
          style: TextStyle(
            color: Colors.blue[700],
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              todos.insert(todoIndex, todo);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );

    errorText = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: todoController,
                    onSubmitted: (e) => addTodo(),
                    decoration: InputDecoration(
                      labelText: 'Nova Terefa',
                      errorText: errorText,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: addTodo,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                  ),
                  child: const Text('ADD'),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (Todo todo in todos)
                    TodoListItem(
                      todo: todo,
                      updateTodoCheck: updateTodoCheck,
                      deleteTodo: deleteTodo,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
