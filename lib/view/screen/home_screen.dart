import 'package:flutter/material.dart';
import 'package:test_app/view/screen/character_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("Pagination"),
              centerTitle: true,
            ),
            body: const CharacterListWidget()));
  }
}
