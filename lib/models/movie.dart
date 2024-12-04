class Movie {
  final String title;
  final String description;
  final String posterUrl;

  Movie({
    required this.title,
    required this.description,
    required this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] ?? 'No Title',
      description:
          json['overview'] ?? 'No Description', // 'overview' in TMDb API
      posterUrl:
          'https://image.tmdb.org/t/p/w500${json['poster_path'] ?? ''}', // TMDb poster image URL
    );
  }
}
