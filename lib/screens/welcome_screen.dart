import 'package:flutter/material.dart';
import 'package:movie_night/widgets/button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: const Offset(0, -70),
                child: Image.asset(
                  'assets/images/background.jpg',
                  width: 300,
                  height: 300,
                ),
              ),
              Text(
                'Welcome to Movie Night!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: buttonPrimary,
                onPressed: () {
                  Navigator.pushNamed(context, '/share-code');
                },
                child: const Text('Start a Session'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: buttonPrimaryLight,
                onPressed: () {
                  Navigator.pushNamed(context, '/enter-code');
                },
                child: const Text('Enter a Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
