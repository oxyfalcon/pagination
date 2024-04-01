import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: Scaffold(body: TestWidget()));
  }
}

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  Future<List<Todo>> api() async {
    List<Todo> todosList = [];
    final http.Response response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));
    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      for (var json in responseBody) {
        todosList.add(Todo.fromJson(json));
      }
      return todosList;
    } else {
      throw ("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
        future: api(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(snapshot.data![index].title));
                });
          } else {
            return Center(child: Text(snapshot.error.toString()));
          }
        });
  }
}

class Todo {
  final int userId;
  final String title;
  final bool completed;

  Todo({required this.userId, required this.title, required this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
      userId: json["userId"],
      title: json["title"],
      completed: json["completed"]);
}
