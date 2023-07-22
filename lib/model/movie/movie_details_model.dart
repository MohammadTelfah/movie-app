/*
this movie details model 
to return details of particular movie 
with it's id
*/

import '../genres_model.dart';

class MovieDetailsModel {
  final MovieDetails? details;
  final String? error;

  MovieDetailsModel({this.details, this.error});

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) =>
      MovieDetailsModel(
        details: MovieDetails.fromJson(json),
        error: '',
      );

  factory MovieDetailsModel.withError(String error) => MovieDetailsModel(
        details: MovieDetails(),
        error: error,
      );
}

class MovieDetails {
  int? id;
  List<Genre>? generes;
  String? releaseDate;
  String? overview;
  String? backDrop;
  String? poster;
  double? rating;
  String? title;
  int? runtime;
  MovieDetails({
    this.id,
    this.generes,
    this.releaseDate,
    this.overview,
    this.backDrop,
    this.poster,
    this.rating,
    this.title,
    this.runtime,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) => MovieDetails(
        id: json['id'],
        generes: (json['genres'] as List)
            .map((genre) => Genre.fromJson(genre))
            .toList(),
        rating: json['vote_average'].toDouble(),
        title: json['title'],
        backDrop: json['backdrop_path'],
        poster: json['poster_path'],
        overview: json['overview'],
        releaseDate: json['release_date'],
        runtime: json['runtime'],
      );
}
