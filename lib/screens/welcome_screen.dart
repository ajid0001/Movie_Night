import 'package:flutter/material.dart';
import 'package:movie_night/screens/share_code_screen.dart';
import 'package:movie_night/screens/enter_code_screen.dart';
import 'package:movie_night/widgets/button.dart';
import 'package:platform_device_id/platform_device_id.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? deviceId;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  Future<void> _getDeviceId() async {
    final id = await PlatformDeviceId.getDeviceId;

    setState(() {
      deviceId = id;
    });
  }

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
                onPressed: deviceId != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShareCodeScreen(
                              deviceId: deviceId!,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Start a Session'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: buttonPrimaryLight,
                onPressed: deviceId != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EnterCodeScreen(),
                          ),
                        );
                      }
                    : null,
                child: const Text('Enter a Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
