// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/model/movie/movie_details_model.dart';
import 'package:movie_app/model/movie/movie_model.dart';
import 'package:movie_app/model/reviews_model.dart';
import 'package:movie_app/model/trailers_models.dart';
import 'package:movie_app/model/tv/tv_details_model.dart';
import 'package:movie_app/model/tv/tv_model.dart';

import '../model/genres_model.dart';

class HttpRequest {
  static final String? apiKey = dotenv.env['API_KEY'];
  static const String mainUrl = 'https://api.themoviedb.org/3';
  static final Dio dio = Dio();
  static var getGenreUrl = '$mainUrl/genre';
  static var getDiscoverUrl = '$mainUrl/discover';
  static var getMoviesUrl = '$mainUrl/movie';
  static var getTVUrl = '$mainUrl/tv';

  // get genres
  static Future<GenreModel> getGenres(String shows) async {
    var params = {"api_key": apiKey, "language": "en-us", "page": 1};
    try {
      // if there is data retrieved, return data
      Response response =
          await dio.get(getGenreUrl + "/$shows/list", queryParameters: params);
      return GenreModel.fromJson(response.data);
    } catch (error) {
      // else return error
      return GenreModel.withError("$error");
    }
  }

  // get reviews
  static Future<ReviewsModel> getReviews(String shows, int id) async {
    var params = {"api_key": apiKey, "language": "en-us", "page": 1};
    try {
      // if there is data retrieved, return data
      Response response = await dio.get(mainUrl + "/$shows/$id/reviews",
          queryParameters: params);
      return ReviewsModel.fromJson(response.data);
    } catch (error) {
      // else return error
      return ReviewsModel.withError("$error");
    }
  }

  // get trailers
  static Future<TrailersModel> getTrailers(String shows, int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-us",
    };
    try {
      // if there is data retrieved, return data
      Response response = await dio.get(mainUrl + "/$shows/$id/videos",
          queryParameters: params);
      return TrailersModel.fromJson(response.data);
    } catch (error) {
      // else return error
      return TrailersModel.withError("$error");
    }
  }

  // get similar movie
  static Future<MovieModel> getSimilarMovies(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-us",
      "page": 1,
    };
    try {
      // if there is data retrieved, return data
      Response response = await dio.get(
        getMoviesUrl + "/$id/similar",
        queryParameters: params,
      );
      return MovieModel.fromJson(response.data);
    } catch (error) {
      // else return error
      return MovieModel.withError("$error");
    }
  }

  // get similar TV shows
  static Future<TVModel> getSimilarTVShows(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-us",
      "page": 1,
    };
    try {
      // if there is data retrieved, return data
      Response response = await dio.get(
        getTVUrl + "/$id/similar",
        queryParameters: params,
      );
      return TVModel.fromJson(response.data);
    } catch (error) {
      // else return error
      return TVModel.withError("$error");
    }
  }

  // discover movies

  static Future<MovieModel> getDiscoverMovies(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-us",
      "page": 1,
      "with_genres": id, //discover movies by genres
    };
    try {
      // if there is data retrieved, return data
      Response response = await dio.get(
        getDiscoverUrl + "/movie",
        queryParameters: params,
      );
      return MovieModel.fromJson(response.data);
    } catch (error) {
      // else return error
      return MovieModel.withError("$error");
    }
  }

  // discover TV shows

  static Future<TVModel> getDiscoverTVShows(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-us",
      "page": 1,
      "with_genres": id, //discover movies by genres
    };
    try {
      // if there is data retrieved, return data
      Response response = await dio.get(
        getDiscoverUrl + "/tv",
        queryParameters: params,
      );
      return TVModel.fromJson(response.data);
    } catch (error) {
      // else return error
      return TVModel.withError("$error");
    }
  }

  // get movie details
  static Future<MovieDetailsModel> getMoviesDetails(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-us",
    };
    try {
      // if there is data retrieved, return data
      Response response = await dio.get(
        getMoviesUrl + "/$id",
        queryParameters: params,
      );
      return MovieDetailsModel.fromJson(response.data);
    } catch (error) {
      // else return error
      return MovieDetailsModel.withError("$error");
    }
  }

  // get tv shows details
  static Future<TVDetailsModel> getTVShowsDetails(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-us",
    };
    try {
      // if there is data retrieved, return data
      Response response = await dio.get(
        getTVUrl + "/$id",
        queryParameters: params,
      );
      return TVDetailsModel.fromJson(response.data);
    } catch (error) {
      // else return error
      return TVDetailsModel.withError("$error");
    }
  }

  // get Movies with different requests
  // such as "now_playing", "popular", "top_rated",and "upcoming"
  static Future<MovieModel> getMovies(String request) async {
    var params = {
      "api_key": apiKey,
      "language": "en-us",
    };
    try {
      // if there is data retrieved, return data
      Response response = await dio.get(
        getMoviesUrl + "/$request",
        queryParameters: params,
      );
      return MovieModel.fromJson(response.data);
    } catch (error) {
      // else return error
      return MovieModel.withError("$error");
    }
  }

  // get tv shows with different requests
  // such as "airing_today", "on_the_air", "top_rated",and "popular"
  static Future<TVModel> getTVShows(String request) async {
    var params = {
      "api_key": apiKey,
      "language": "en-us",
    };
    try {
      // if there is data retrieved, return data
      Response response = await dio.get(
        getTVUrl + "/$request",
        queryParameters: params,
      );
      return TVModel.fromJson(response.data);
    } catch (error) {
      // else return error
      return TVModel.withError("$error");
    }
  }
}
