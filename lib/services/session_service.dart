import 'dart:convert';
import 'package:http/http.dart' as http;
// import '../models/session.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class SessionService {
  static const String baseUrl = "https://movie-night-api.onrender.com";
  String? _sessionId;

  // Method to start a session
  Future<Map<String, String>> startSession(String deviceId) async {
    // Future<void> startSession(String deviceId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/start-session?device_id=$deviceId'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _sessionId = data['data']['session_id'];
        print('Session started: $_sessionId');
        print('device id 1: $deviceId');

        return {
          'sessionId': data['data']['session_id'],
          'code': data['data']['code'],
        };
      } else {
        throw Exception('Failed to generate session code');
      }
    } catch (e) {
      throw Exception('Failed to start session: $e');
    }
  }

  String getSessionId() {
    if (_sessionId == null) {
      throw Exception(
          'Session ID is not available. Please start or join a session.');
    }
    return _sessionId!;
  }

  // Method to join a session using a code
  Future<List<Movie>> joinSession(String code, String deviceId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/join-session?device_id=$deviceId&code=${int.parse(code)}'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // String sessionId = data['data']['session_id'];
        _sessionId = data['data']['session_id'];
        print('Joined session: $_sessionId');
        print('Response body: ${response.body}');
        print('device id 2: $deviceId');

        List<Movie> movies = await MovieService().fetchMovies();
        return movies;
      } else {
        // print("Response body: ${response.body}");
        throw Exception('Invalid code or session not found');
      }
    } catch (e) {
      // print("Error: $e");
      throw Exception('Failed to join session: $e');
    }
  }

  Future<bool> voteMovie(String sessionId, int movieId, bool vote) async {
    final uri = Uri.parse('$baseUrl/vote-movie').replace(queryParameters: {
      'session_id': sessionId,
      'movie_id': movieId.toString(),
      'vote': vote.toString(),
    });

    final response = await http.get(uri);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      print('Vote result: ${data['message']}');
      print('Match: ${data['match']}');
      print('Num devices: ${data['num_devices']}');
      print('sessionid: $sessionId');
      return data['match'] as bool;
    } else {
      throw Exception('Failed to vote for the movie');
    }
  }
}
