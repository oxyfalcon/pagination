import 'package:flutter/material.dart';
import 'package:test_app/view/screen/character_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Scaffold(body: CharacterListWidget()));
  }
}
