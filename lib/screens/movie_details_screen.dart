// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/model/hive_movie_model.dart';
import 'package:movie_app/movie_widgets/similar_movie_widget.dart';
import 'package:movie_app/screens/reviews.dart';
import 'package:movie_app/screens/trailers_screen.dart';

import '../constant/style.dart';
import '../model/movie/movie_model.dart';
import '../movie_widgets/movie_info.dart';

class MoviesDetailsScreen extends StatefulWidget {
  const MoviesDetailsScreen({super.key, required this.movie, this.request});
  final Movie movie; // pass movie details inside here
  final String? request;
  @override
  State<MoviesDetailsScreen> createState() => _MoviesDetailsScreenState();
}

class _MoviesDetailsScreenState extends State<MoviesDetailsScreen> {
  late Box<HiveMovieModel> _movieWatchLists;
  @override
  void initState() {
    _movieWatchLists = Hive.box<HiveMovieModel>('movie_lists');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movie.title!,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // build banner
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildBackDrop(),
                Positioned(
                  top: 150,
                  left: 30,
                  child: Hero(
                    tag: widget.request == null
                        ? "${widget.movie.id}"
                        : "${widget.movie.id}" + widget.request!,
                    child: _buildPoster(),
                  ),
                ),
              ],
            ),
            MovieInfo(
              id: widget.movie.id!,
            ),
            SimilarMovies(id: widget.movie.id!),
            Reviews(
              id: widget.movie.id!,
              request: 'movie',
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.redAccent,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TrailersScreen(
                          id: widget.movie.id!,
                          shows: 'movie',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.play_circle_fill_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Watch Trailers',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Style.secondColor,
                child: TextButton.icon(
                  onPressed: () {
                    HiveMovieModel newValue = HiveMovieModel(
                      id: widget.movie.id!,
                      rating: widget.movie.rating!,
                      title: widget.movie.title!,
                      backDrop: widget.movie.backDrop!,
                      poster: widget.movie.poster!,
                      overview: widget.movie.overview!,
                    );
                    _movieWatchLists.add(newValue);
                    showAlertDialog();
                  },
                  icon: const Icon(
                    Icons.list_alt_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add to Lists',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPoster() {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(
            'https://image.tmdb.org/t/p/w200/' + widget.movie.poster!,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBackDrop() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(
            'https://image.tmdb.org/t/p/original/' + widget.movie.backDrop!,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (contex) {
        return AlertDialog(
          title: const Text('Added to List'),
          content:
              Text('${widget.movie.title!} successfully added to watch list'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
