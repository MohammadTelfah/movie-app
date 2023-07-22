class MovieModel {
  final List<Movie>? movies;
  final String? error;
  MovieModel({this.movies, this.error});

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        movies: (json['results'] as List)
            .map((data) => Movie.fromJson(data))
            .toList(),
        error: "",
      );
  // this model is in case the  error return from api
  factory MovieModel.withError(String error) => MovieModel(
        movies: [],
        error: error,
      );
}

class Movie {
  int? id;
  double? rating;
  String? title;
  String? backDrop;
  String? poster;
  String? overview;
  Movie({
    this.id,
    this.title,
    this.backDrop,
    this.overview,
    this.poster,
    this.rating,
  });
  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'],
        rating: json['vote_average'].toDouble(),
        title: json['title'],
        backDrop: json['backdrop_path'],
        poster: json['poster_path'],
        overview: json['overview'],
      );
}
