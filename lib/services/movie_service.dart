import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  final String _apiKey = '252a4626e441c706b2114a01e4ee051c';
  final String _baseUrl = 'https://api.themoviedb.org/3/movie/popular';

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl?api_key=$_apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['results'];
      return data.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to fetch movies');
    }
  }
}
