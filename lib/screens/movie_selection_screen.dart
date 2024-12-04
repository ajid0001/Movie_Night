import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieSelectionScreen extends StatefulWidget {
  const MovieSelectionScreen({super.key});

  @override
  _MovieSelectionScreenState createState() => _MovieSelectionScreenState();
}

class _MovieSelectionScreenState extends State<MovieSelectionScreen> {
  late Future<List<Movie>> _movies;
  String errorMessage = '';
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _movies = MovieService().fetchMovies().catchError((error) {
      setState(() {
        errorMessage = error.toString();
      });
      return [];
    });
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Selection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: errorMessage.isEmpty
              ? FutureBuilder<List<Movie>>(
                  future: _movies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No movies found');
                    }

                    return PageView.builder(
                      controller: _pageController, 
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Movie movie = snapshot.data![index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize
                                  .min, 
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Hero(
                                  tag: movie.title, 
                                  child: Image.network(
                                    movie.posterUrl,
                                    height: 300,
                                    width:
                                        200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  movie.title,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    movie.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                ),
        ),
      ),
    );
  }
}
