class Movie {
  final int id;
  final String title;
  final String description;
  final String posterUrl;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      description: json['overview'],
      posterUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path'] ?? ''}',
    );
  }
}
