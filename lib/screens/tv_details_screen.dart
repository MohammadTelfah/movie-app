// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/model/tv/tv_model.dart';
import 'package:movie_app/screens/reviews.dart';
import 'package:movie_app/tv_widgets/similar_tv_widget.dart';

import '../constant/style.dart';
import '../model/hive_tv_model.dart';
import '../tv_widgets/tv_info.dart';
import 'trailers_screen.dart';

class TVsDetailsScreen extends StatefulWidget {
  const TVsDetailsScreen({super.key, required this.tvShows, this.request});
  final TVShows tvShows; // pass tv shows details inside here
  final String? request;
  @override
  State<TVsDetailsScreen> createState() => _TVsDetailsScreenState();
}

class _TVsDetailsScreenState extends State<TVsDetailsScreen> {
  late Box<HiveTVModel> _tvWatchLists;
  @override
  void initState() {
    _tvWatchLists = Hive.box<HiveTVModel>('tv_lists');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tvShows.name!,
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
                        ? "${widget.tvShows.id}"
                        : "${widget.tvShows.id}" + widget.request!,
                    child: _buildPoster(),
                  ),
                ),
              ],
            ),
            TVsInfo(
              id: widget.tvShows.id!,
            ),
            SimilarTVs(id: widget.tvShows.id!),
            Reviews(
              id: widget.tvShows.id!,
              request: 'tv',
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
                          id: widget.tvShows.id!,
                          shows: 'tv',
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
                    HiveTVModel newValue = HiveTVModel(
                      id: widget.tvShows.id!,
                      rating: widget.tvShows.rating!,
                      name: widget.tvShows.name!,
                      backDrop: widget.tvShows.backDrop!,
                      poster: widget.tvShows.poster!,
                      overview: widget.tvShows.overview!,
                    );
                    _tvWatchLists.add(newValue);
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
            'https://image.tmdb.org/t/p/w200/' + widget.tvShows.poster!,
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
            'https://image.tmdb.org/t/p/original/' + widget.tvShows.backDrop!,
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
              Text('${widget.tvShows.name!} successfully added to watch list'),
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
