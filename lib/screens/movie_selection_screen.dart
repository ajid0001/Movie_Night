import 'package:flutter/material.dart';

class MovieSelectionScreen extends StatelessWidget {
  const MovieSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Selection')),
      body: const Center(child: Text('Movie selection goes here!')),
    );
  }
}
