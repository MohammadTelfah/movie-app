// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:movie_app/constant/style.dart';
import 'package:movie_app/model/tv/tv_model.dart';
import 'package:movie_app/screens/tv_details_screen.dart';

import '../http/http_request.dart';

class TVsWidget extends StatefulWidget {
  const TVsWidget({
    Key? key,
    required this.text,
    required this.request,
  }) : super(key: key);
  final String text;
  final String request;

  @override
  State<TVsWidget> createState() => _TVsWidgetState();
}

class _TVsWidgetState extends State<TVsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 20),
          child: Text(
            '${widget.text} TV SHOWS',
            style: const TextStyle(
              color: Style.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        FutureBuilder<TVModel>(
          // get upcoming list of movies from api
          future: HttpRequest.getTVShows(widget.request),
          builder: (context, AsyncSnapshot<TVModel> snapshot) {
            if (snapshot.hasData) {
              // if error data return, display error on screen
              if (snapshot.data!.error != null &&
                  snapshot.data!.error!.isNotEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              // else, return "movie" by upcoming request
              return _buildTVsByGenreWidget(snapshot.data!);
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

  Widget _buildTVsByGenreWidget(TVModel data) {
    List<TVShows>? tvShows = data.tvShows;
    if (tvShows!.isEmpty) {
      return const SizedBox(
        child: Text(
          'No TV Shows found',
          style: TextStyle(
            fontSize: 20,
            color: Style.textColor,
          ),
        ),
      );
    } else {
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
                      builder: (_) => TVsDetailsScreen(
                        tvShows: tvShows[index],
                        request: widget.request,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: <Widget>[
                    tvShows[index].poster == null
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
                            tag: "${tvShows[index].id}" + widget.request,
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
                                          tvShows[index].poster!),
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
                        tvShows[index].name!,
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
                          tvShows[index].rating.toString(),
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
                      initialRating: tvShows[index].rating! / 2,
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
          itemCount: tvShows.length,
          scrollDirection: Axis.horizontal,
        ),
      );
    }
  }
}
