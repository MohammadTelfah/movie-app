// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constant/style.dart';
import '../http/http_request.dart';
import '../model/movie/movie_model.dart';
import '../screens/movie_details_screen.dart';

class SimilarMovies extends StatefulWidget {
  const SimilarMovies({super.key, required this.id});
  final int id;

  @override
  State<SimilarMovies> createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            'SIMILAR MOVIES',
            style: TextStyle(
              color: Style.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        FutureBuilder<MovieModel>(
          // get upcoming list of movies from api
          future: HttpRequest.getSimilarMovies(widget.id),
          builder: (context, AsyncSnapshot<MovieModel> snapshot) {
            if (snapshot.hasData) {
              // if error data return, display error on screen
              if (snapshot.data!.error != null &&
                  snapshot.data!.error!.isNotEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              // else, return "movie" by upcoming request
              return _buildSimilarMoviesWidget(snapshot.data!);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              // return loading indicator while retrieving data
              return buildLoadingWidget();
            }
          },
        ),
      ],
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Something is wrong : $error',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarMoviesWidget(MovieModel data) {
    List<Movie>? movies = data.movies;
    if (movies!.isEmpty) {
      return const SizedBox(
        child: Text(
          'No Similar Movies found',
          style: TextStyle(
            fontSize: 20,
            color: Style.textColor,
          ),
        ),
      );
    } else {
      // else return movie poster and rating
      return Container(
        padding: const EdgeInsets.only(left: 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                right: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MoviesDetailsScreen(
                        movie: movies[index],
                      ),
                    ),
                  );
                },
                child: Column(
                  children: <Widget>[
                    movies[index].poster == null
                        ? Container(
                            // if poster is return null , show cam_off icon
                            width: 120,
                            height: 180,
                            decoration: const BoxDecoration(
                              color: Style.secondColor,
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(2)),
                              shape: BoxShape.rectangle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.videocam_off,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          )
                        : Hero(
                            tag: "${movies[index].id}",
                            child: Container(
                              width: 120,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Style.secondColor,
                                borderRadius: const BorderRadiusDirectional.all(
                                    Radius.circular(2)),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w200/' +
                                          movies[index].poster!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        movies[index].title!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // display rating below poster
                    Row(
                      children: <Widget>[
                        Text(
                          movies[index].rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    RatingBar.builder(
                      itemSize: 8,
                      initialRating: movies[index].rating! / 2,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                      itemBuilder: (context, _) {
                        return const Icon(
                          Icons.star,
                          color: Style.secondColor,
                        );
                      },
                      onRatingUpdate: (rating) {},
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: movies.length,
          scrollDirection: Axis.horizontal,
        ),
      );
    }
  }
}
