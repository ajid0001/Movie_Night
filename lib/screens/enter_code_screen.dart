import 'package:flutter/material.dart';

class EnterCodeScreen extends StatelessWidget {
  const EnterCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter the Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Code: ${_controller.text}');
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
