import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/API/api.dart';
import 'package:movie_app/Database%20helper.dart';
import 'package:movie_app/Fav%20Screen.dart';
import 'package:movie_app/Movie%20Detail%20Screen.dart';
import 'package:sqflite/sqflite.dart';

import 'Model/movie_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Movie_model>> upcomingMovies;
  late Future<List<Movie_model>> topRatedMovies;
  late Future<List<Movie_model>> popularMovies;

  @override
  void initState() {
    super.initState();
    upcomingMovies = API().getUpcomingMovies();
    topRatedMovies = API().getTopRatedMovies();
    popularMovies = API().getPopularMovies();
    Database_helper.instance.createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
          ),
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => fav_screen()),);
          },
        ),
        centerTitle: true,
        title: Text(
          "Show Spot",
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "UpComing",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.amber,
                ),
              ),
              FutureBuilder(
                  future: upcomingMovies,
                  builder: (context, snaphot) {
                    if (!snaphot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final movies = snaphot.data!;
                    return CarouselSlider.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index, movieindex) {
                        final movie = movies[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    movieDetailScreen(movie: movie),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.network(
                                "https://image.tmdb.org/t/p/original/${movie.backDropPath}"),
                          ),
                        );
                      },
                      options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 1.4,
                          autoPlayInterval: const Duration(seconds: 3)),
                    );
                  }),
              Text(
                "Popular",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.amber,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 200,
                child: FutureBuilder(
                    future: popularMovies,
                    builder: (context, snaphot) {
                      if (!snaphot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final movies = snaphot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      movieDetailScreen(movie: movie),
                                ),
                              );
                            },
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child:Image.network(
                                    "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,) ,
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
              Text(
                "Top Rated",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.amber,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                height: 200,
                child: FutureBuilder(
                    future: topRatedMovies,
                    builder: (context, snaphot) {
                      if (!snaphot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final movies = snaphot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      movieDetailScreen(movie: movie),
                                ),
                              );
                            },
                            child: Container(
                              width: 150,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child:Image.network(
                                  "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,) ,
                              ),
                            ),
                          );
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
