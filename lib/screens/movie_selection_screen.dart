import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:movie_night/models/session.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/session_service.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  MovieSelectionScreenState createState() => MovieSelectionScreenState();
}

class MovieSelectionScreenState extends State<MovieSelectionScreen> {
  late Future<List<Movie>> _movies;
  final SwiperController _swiperController = SwiperController();
  String errorMessage = '';
  bool isMatchFound = false;
  String sessionId = '';

  @override
  void initState() {
    super.initState();
    _initializeSession();
    _fetchMovies();
  }

  Future<void> _initializeSession() async {
    try {
      String? storedSessionId = await SessionService().getSessionId();
      if (storedSessionId == null || storedSessionId.isEmpty) {
        String deviceId = await _getDeviceId();
        Session sessionData = await SessionService().startSession(deviceId);
        await SessionService.saveSessionId(sessionData.sessionId);
        setState(() {
          sessionId = sessionData.sessionId;
        });
        print('Session ID: $sessionId');
      } else {
        setState(() {
          sessionId = storedSessionId;
        });
        print('Retrieved Session ID: $sessionId');
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to fetch session ID: $error';
      });
    }
  }

  Future<void> _fetchMovies() async {
    setState(() {
      _movies = MovieService().fetchMovies().catchError((error) {
        setState(() {
          errorMessage = error.toString();
        });
        return [];
      });
    });
  }

  Future<String> _getDeviceId() async {
    final deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId ?? 'unknown_device_id';
  }

  Future<void> _handleSelection(Movie movie, bool vote) async {
    final String? currentSessionId = await SessionService().getSessionId();

    if (currentSessionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Session ID is invalid. Please start or join a session.'),
        ),
      );
      return;
    }

    try {
      final bool isMatch =
          await SessionService().voteMovie(currentSessionId, movie.id, vote);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vote
              ? 'You liked "${movie.title}"!'
              : 'You skipped "${movie.title}".'),
          duration: const Duration(seconds: 2),
        ),
      );

      if (isMatch && !isMatchFound) {
        setState(() {
          isMatchFound = true;
        });
        _showMatchPopup(movie);
      }

      _swiperController.next();
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
          content: Text('Both users selected: "${movie.title}"'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLikeButton(Movie movie) {
    return ElevatedButton(
      onPressed: () => _handleSelection(movie, true),
      child: const Text('Like'),
    );
  }

  Widget _buildSkipButton(Movie movie) {
    return ElevatedButton(
      onPressed: () => _handleSelection(movie, false),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
      ),
      child: const Text('Skip'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Choices'),
      ),
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
                    controller: _swiperController, // Attach controller
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
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLikeButton(movie),
                              const SizedBox(width: 20),
                              _buildSkipButton(movie),
                            ],
                          ),
                        ],
                      );
                    },
                    pagination: const SwiperPagination(),
                    control: const SwiperControl(),
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
