import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_night/models/session.dart';
import '../services/session_service.dart';
import 'movie_selection_screen.dart';
import 'package:movie_night/widgets/button.dart';

class ShareCodeScreen extends StatefulWidget {
  final String deviceId;

  const ShareCodeScreen({
    super.key,
    required this.deviceId,
  });

  @override
  ShareCodeScreenState createState() => ShareCodeScreenState();
}

class ShareCodeScreenState extends State<ShareCodeScreen> {
  String? sessionId;
  String? code;
  String? errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateSessionCode();
  }

  Future<void> _generateSessionCode() async {
    setState(() {
      _isLoading = true;
      errorMessage = null;
    });

    try {
      final Session session =
          await SessionService().startSession(widget.deviceId);
      await SessionService.saveSessionId(session.sessionId);

      setState(() {
        sessionId = session.sessionId;
        code = session.code.toString().padLeft(4, '0');
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to generate session code. Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyCodeToClipboard() {
    if (code != null) {
      Clipboard.setData(ClipboardData(text: code!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Code copied to clipboard',
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToMovieSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MovieSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Code'),
      ),
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
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (errorMessage != null)
                          Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        if (sessionId != null && code != null)
                          Column(
                            children: [
                              const Text(
                                'Share the code with your friend!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    code!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    color: Colors.black,
                                    tooltip: 'Copy Code',
                                    onPressed: _copyCodeToClipboard,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: buttonPrimary,
                                onPressed: _navigateToMovieSelection,
                                child: const Text('Start Movie Matching'),
                              ),
                            ],
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
