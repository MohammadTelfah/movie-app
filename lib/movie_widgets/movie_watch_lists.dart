// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/constant/style.dart';
import 'package:movie_app/model/hive_movie_model.dart';

class MovieWatchLists extends StatefulWidget {
  const MovieWatchLists({super.key});

  @override
  State<MovieWatchLists> createState() => _MovieWatchListsState();
}

class _MovieWatchListsState extends State<MovieWatchLists> {
  late Box<HiveMovieModel> _movieWatchLists;
  @override
  void initState() {
    _movieWatchLists = Hive.box<HiveMovieModel>('movie_lists');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: _movieWatchLists.isEmpty
          ? const Center(
              child: Text(
                'No Movies added to list yet!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Style.textColor,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ValueListenableBuilder(
                    valueListenable: _movieWatchLists.listenable(),
                    builder: (context, Box<HiveMovieModel> item, _) {
                      List<int> keys = item.keys.cast<int>().toList();
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          final key = keys[index];
                          final HiveMovieModel? _item = item.get(key);
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(_item!.title),
                              subtitle: Text(
                                _item.overview,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Image.network(
                                'https://image.tmdb.org/t/p/w200' +
                                    _item.poster,
                                fit: BoxFit.cover,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _movieWatchLists.deleteAt(index);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
