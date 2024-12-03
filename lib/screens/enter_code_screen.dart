import 'package:flutter/material.dart';


class EnterCodeScreen extends StatelessWidget {
  const EnterCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Code')),
      body: const Center(child: Text('Enter Code Screen')),
    );
  }
}
