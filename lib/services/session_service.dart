import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/session.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class SessionService {
  static const String baseUrl = "https://movie-night-api.onrender.com";

  // Method to start a session
  Future<Map<String, String>> startSession(String deviceId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/start-session?device_id=$deviceId'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
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

  // Method to join a session using a code
  Future<List<Movie>> joinSession(String code, String deviceId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/join-session?device_id=$deviceId&code=${int.parse(code)}'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String sessionId = data['data']['session_id'];

        List<Movie> movies = await MovieService().fetchMovies();
        return movies;
      } else {
        print("Failed to join session: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception(
            'Failed to join session. Invalid code or session not found');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Failed to join session: $e');
    }
  }
}
