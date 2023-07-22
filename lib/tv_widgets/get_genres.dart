import 'package:flutter/material.dart';
import 'package:movie_app/model/genres_model.dart';
import 'package:movie_app/movie_widgets/genres_list.dart';

import '../constant/style.dart';
import '../http/http_request.dart';

// this is to get genres from API
class GetGenres extends StatefulWidget {
  const GetGenres({super.key});

  @override
  State<GetGenres> createState() => _GetGenresState();
}

class _GetGenresState extends State<GetGenres> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GenreModel>(
      // get genres list of TV shows from api
      future: HttpRequest.getGenres('tv'),
      builder: (context, AsyncSnapshot<GenreModel> snapshot) {
        if (snapshot.hasData) {
          // if error data return, display error on screen
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          // else, return "TV shows" by genre
          return _buildGetGenresWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          // return loading indicator while retrieving data
          return buildLoadingWidget();
        }
      },
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

  Widget _buildGetGenresWidget(GenreModel data) {
    List<Genre>? genres = data.genres;
    if (genres!.isEmpty) {
      return const SizedBox(
        child: Text(
          'no Genres',
          style: TextStyle(
            fontSize: 20,
            color: Style.textColor,
          ),
        ),
      );
    } else {
      return GenreLists(genres: genres);
    }
  }
}
