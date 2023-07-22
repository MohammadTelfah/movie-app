import 'package:flutter/material.dart';
import 'package:movie_app/model/trailers_models.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../http/http_request.dart';

class TrailersScreen extends StatefulWidget {
  const TrailersScreen({super.key, required this.id, required this.shows});
  final String shows;
  final int id;

  @override
  State<TrailersScreen> createState() => _TrailersScreenState();
}

class _TrailersScreenState extends State<TrailersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TrailersModel>(
        // get upcoming list of movies from api
        future: HttpRequest.getTrailers(widget.shows, widget.id),
        builder: (context, AsyncSnapshot<TrailersModel> snapshot) {
          if (snapshot.hasData) {
            // if error data return, display error on screen
            if (snapshot.data!.error != null &&
                snapshot.data!.error!.isNotEmpty) {
              return _buildErrorWidget(snapshot.data!.error);
            }
            return _buildTrailersWidget(snapshot.data!);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else {
            // return loading indicator while retrieving data
            return buildLoadingWidget();
          }
        },
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

  Widget _buildTrailersWidget(TrailersModel data) {
    List<Video>? videos = data.trailers;
    return Stack(
      children: <Widget>[
        Center(
          child: YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: videos![0].key!,
              flags: const YoutubePlayerFlags(
                hideControls: true,
                autoPlay: true,
              ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_sharp),
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
