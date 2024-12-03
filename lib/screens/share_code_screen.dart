import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  _ShareCodeScreenState createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String? code;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCode();
  }

  Future<void> _fetchCode() async {
    try {
      final response =
          await http.get(Uri.parse(''));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          code = data['code'];
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch code.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Code')),
      body: Center(
        child: errorMessage != null
            ? Text(errorMessage!)
            : code != null
                ? Text('Your Code: $code')
                : const CircularProgressIndicator(),
      ),
    );
  }
}
