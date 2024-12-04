import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../services/session_service.dart';
import '../models/movie.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  _EnterCodeScreenState createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final TextEditingController _controller = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  Future<String> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = "";

    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id ?? "unknown_device_id";
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? "unknown_device_id";
      } else {
        deviceId = "unknown_device_id";
      }
    } catch (e) {
      deviceId = "unknown_device_id";
      print("Failed to get device ID: $e");
    }

    return deviceId;
  }

  Future<void> _joinSession() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    String code = _controller.text.trim();

    if (code.isEmpty) {
      setState(() {
        errorMessage = 'Code cannot be empty';
        isLoading = false;
      });
      return;
    }

    try {
      String deviceId = await _getDeviceId();
      List<Movie> movies = await SessionService().joinSession(code, deviceId);

      Navigator.pushNamed(context, '/movie-selection', arguments: movies);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to join session: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter the session code below:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _joinSession,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Join Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
