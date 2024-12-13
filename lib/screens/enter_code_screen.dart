import 'package:flutter/material.dart';
import 'package:movie_night/models/session.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../services/session_service.dart';
import 'movie_selection_screen.dart';
import 'package:movie_night/widgets/button.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  EnterCodeScreenState createState() => EnterCodeScreenState();
}

class EnterCodeScreenState extends State<EnterCodeScreen> {
  final TextEditingController _controller = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  Future<String> _getDeviceId() async {
    final deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId ?? 'unknown_device_id';
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
      final Session session =
          await SessionService().joinSession(deviceId, code);
      await SessionService.saveSessionId(session.sessionId);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MovieSelectionScreen(),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to join session: $e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Code')),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(0, 246, 239, 239),
                    Color.fromARGB(255, 206, 116, 228),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter the code from your friend:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Enter Code',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: buttonPrimary,
                      onPressed: isLoading ? null : _joinSession,
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Join Session'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
