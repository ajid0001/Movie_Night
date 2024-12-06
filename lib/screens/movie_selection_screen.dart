import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/session_service.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  _MovieSelectionScreenState createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  late Future<List<Movie>> _movies;
  String errorMessage = '';
  bool isMatchFound = false;
  String sessionId = 'your-session-id';

  @override
  void initState() {
    super.initState();
    _movies = MovieService().fetchMovies().catchError((error) {
      setState(() {
        errorMessage = error.toString();
      });
      return [];
    });
  }

  Future<void> _handleSelection(Movie movie, bool vote) async {
    try {
      bool isMatch =
          await SessionService().voteMovie(sessionId, movie.id, vote);

      if (isMatch && !isMatchFound) {
        setState(() {
          isMatchFound = true;
        });
        _showMatchPopup(movie);
      }
    } catch (e) {
      // print('Error voting for movie: $e');
    }
  }

  void _showMatchPopup(Movie movie) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Match Found!'),
          content: Text('Both users selected: ${movie.title}'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Choices')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: errorMessage.isEmpty
            ? FutureBuilder<List<Movie>>(
                future: _movies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError || snapshot.data == null) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.data!.isEmpty) {
                    return const Center(child: Text('No movies found.'));
                  }

                  return Swiper(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final movie = snapshot.data![index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: movie.title,
                            child: Image.network(
                              movie.posterUrl,
                              height: 300,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            movie.title,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              movie.description,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      );
                    },
                    pagination: const SwiperPagination(),
                    control: const SwiperControl(),
                    onIndexChanged: (index) {
                      print('Movie index changed to $index');
                    },
                    onTap: (index) {
                      final selectedMovie = snapshot.data![index];
                      _handleSelection(
                          selectedMovie, true);
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
      ),
    );
  }
}
