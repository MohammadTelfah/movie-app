import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constant/style.dart';
import 'model/hive_movie_model.dart';
import 'model/hive_tv_model.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(HiveMovieModelAdapter());
  Hive.registerAdapter(HiveTVModelAdapter());
  await Hive.openBox<HiveMovieModel>('movie_lists');
  await Hive.openBox<HiveTVModel>('tv_lists');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Style.primaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Style.primaryColor,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
