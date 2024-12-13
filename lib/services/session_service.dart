import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class SessionService {
  static const String baseUrl = "https://movie-night-api.onrender.com";
  static const String _sessionKey = 'session_id';

  // Method to start a session
  Future<Session> startSession(String deviceId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/start-session?device_id=$deviceId'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final session = Session.fromJson(data);
        return session;
      } else {
        throw Exception('Failed to generate session code');
      }
    } catch (e) {
      throw Exception('Failed to start session: $e');
    }
  }

  // Method to save session ID to SharedPreferences
  static Future<void> saveSessionId(String sessionId) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(_sessionKey, sessionId);
    } catch (e) {
      throw Exception('Failed to save session ID: $e');
    }
  }

  // Method to retrieve session ID from SharedPreferences
  Future<String?> getSessionId() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final sessionId = preferences.getString(_sessionKey);
      return sessionId;
    } catch (e) {
      throw Exception('Failed to get session ID: $e');
    }
  }

  // Method to join a session using a code
  Future<Session> joinSession(String deviceId, String code) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/join-session?device_id=$deviceId&code=${int.parse(code)}'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final session = Session.fromJson(data);
        return session;
      } else {
        throw Exception('Invalid code or session not found');
      }
    } catch (e) {
      throw Exception('Failed to join session: $e');
    }
  }

  // Method to vote for a movie
  Future<bool> voteMovie(String sessionId, int movieId, bool vote) async {
    final uri = Uri.parse('$baseUrl/vote-movie').replace(queryParameters: {
      'session_id': sessionId,
      'movie_id': movieId.toString(),
      'vote': vote.toString(),
    });

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        return data['match'] as bool;
      } else {
        throw Exception('Failed to vote for the movie');
      }
    } catch (e) {
      throw Exception('Failed to vote for the movie: $e');
    }
  }
}
