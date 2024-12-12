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
  String sessionId = ''; 

  @override
  void initState() {
    super.initState();

    _initializeSession(); 

    _movies = MovieService().fetchMovies().catchError((error) {
      setState(() {
        errorMessage = error.toString();
      });
      return [];
    });
  }

  Future<void> _initializeSession() async {
    try {
      if (sessionId.isEmpty) {
        String deviceId =
            await _getDeviceId();
        Map<String, String> sessionData =
            await SessionService().startSession(deviceId);
        setState(() {
          sessionId = sessionData['sessionId']!; 
        });
        print('Session IDDDD: $sessionId');
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to fetch session ID: $error';
      });
    }
  }

  Future<String> _getDeviceId() async {
    return 'your-device-id'; 
  }

  Future<void> _handleSelection(Movie movie, bool vote) async {
    if (sessionId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Session ID is invalid. Please start or join a session.')),
      );
      return;
    }

    try {
      final isMatch =
          await SessionService().voteMovie(sessionId, movie.id, vote);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vote
              ? 'You liked ${movie.title}!'
              : 'You skipped ${movie.title}.'),
          duration: const Duration(seconds: 2),
        ),
      );

      if (isMatch && !isMatchFound) {
        setState(() {
          isMatchFound = true;
        });
        _showMatchPopup(movie);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
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
                    onIndexChanged: (index) {},
                    onTap: (index) {
                      final movie = snapshot.data![index];
                      _handleSelection(movie, true);
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
