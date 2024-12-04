// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ShareCodeScreen extends StatefulWidget {
//   const ShareCodeScreen({super.key});

//   @override
//   _ShareCodeScreenState createState() => _ShareCodeScreenState();
// }

// class _ShareCodeScreenState extends State<ShareCodeScreen> {
//   String? code;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCode();
//   }

//   Future<void> _fetchCode() async {
//     try {
//       final response = await http.get(Uri.parse(
//           'https://api.themoviedb.org/3/movie/popular?api_key=252a4626e441c706b2114a01e4ee051c&page=1'));

//       if (response.statusCode == 200) {
//         print(response.body);
//         var data = json.decode(response.body);
//         setState(() {
//           code = data['code'];
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Failed to fetch code.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Share Code')),
//       body: Center(
//         child: errorMessage != null
//             ? Text(errorMessage!)
//             : code != null
//                 ? Text('Your Code: $code')
//                 : const CircularProgressIndicator(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';

class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  _ShareCodeScreenState createState() => _ShareCodeScreenState();
}

class _ShareCodeScreenState extends State<ShareCodeScreen> {
  String? sessionId;
  String? code;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _generateSessionCode();
  }

  Future<void> _generateSessionCode() async {
    String deviceId = await _getDeviceId();

    try {
      final response = await http.get(
        Uri.parse(
            'https://movie-night-api.onrender.com/start-session?device_id=$deviceId'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          sessionId = data['data']['session_id'];
          code = data['data']['code'];
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to generate session code. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error occurred while making the request: $e';
      });
    }
  }

  // Method to fetch device ID
  Future<String> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = "";

    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId =
            androidInfo.id ?? "unknown_device_id";
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ??
            "unknown_device_id";
      } else {
        deviceId = "unknown_device_id";
      }
    } catch (e) {
      deviceId = "unknown_device_id";
      print("Failed to get device ID: $e");
    }

    return deviceId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              if (sessionId != null && code != null)
                Column(
                  children: [
                    Text(
                      'Session ID: $sessionId',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Code: $code',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (sessionId != null && code != null) {
                    Navigator.pushNamed(context, '/movie-selection');
                  }
                },
                child: const Text('Start Movie Matching'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
