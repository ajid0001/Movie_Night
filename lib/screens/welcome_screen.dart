import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Night')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Movie Night!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Share Code Screen
                Navigator.pushNamed(context, '/share-code');
              },
              child: Text('Get a Code to Share'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Enter Code Screen
                Navigator.pushNamed(context, '/enter-code');
              },
              child: Text('Enter a Code'),
            ),
          ],
        ),
      ),
    );
  }
}
