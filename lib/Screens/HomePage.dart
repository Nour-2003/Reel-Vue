
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Model/movie_model.dart';
import '../Services/API/api.dart';
import '../cubit/App States.dart';
import '../cubit/Cubit.dart';
import 'Fav Screen.dart';
import 'Movie Detail Screen.dart';
import 'SearchScreen.dart';

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
    // Database_helper.instance.createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
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
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Searchscreen()),);
                },
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
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
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
                                  child: Stack(
                                    children: [
                                      // "https://image.tmdb.org/t/p/original/${movie.backDropPath}".isNotEmpty
                                      //     ? FadeInImage.assetNetwork(
                                      //     width: double.infinity,
                                      //     fit: BoxFit.cover,
                                      //     placeholder: "images/Animation - 1720202353247.gif",
                                      //     image:"https://image.tmdb.org/t/p/original/${movie.backDropPath}")
                                      //     : Image.asset("images/placeholder.png", width: double.infinity,
                                      //   fit: BoxFit.cover,),
                                      Image.network(
                                        "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      // Positioned text overlay for movie name
                                      Positioned(
                                        bottom: 100, // Positioning the text at the bottom
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          color: Colors.black.withOpacity(0.5), // Adding a semi-transparent background
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            movie.title, // Movie name from your movie object
                                            style:  GoogleFonts.montserrat(
                                              color: Colors.white, // White color for contrast
                                              fontSize: 18,        // Adjust size as needed
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            );
                          },
                          options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 1.3,
                              autoPlayInterval: const Duration(seconds: 4)),
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
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
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
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 170,
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: "https://image.tmdb.org/t/p/original/${movie.backDropPath}".isNotEmpty
                                            ? FadeInImage.assetNetwork(
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: "images/Animation - 1720202353247.gif",
                                            image:"https://image.tmdb.org/t/p/original/${movie.backDropPath}")
                                            : Image.asset("images/placeholder.png"),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0, // Set the movie name 100 pixels above the bottom
                                      left: 10,    // Add padding from the left for positioning
                                      right: 10,   // Padding from the right
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        color: Colors.black.withOpacity(0.5), // Slightly transparent background
                                        child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            movie.title, // Ensure this contains the movie name
                                            style: GoogleFonts.montserrat(
                                              color: Colors.white, // White color for contrast
                                              fontSize: 16,        // Adjust size as needed
                                              fontWeight: FontWeight.bold,
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
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
                              child: CircularProgressIndicator(    color: Colors.white,),
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
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 170,
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child:  "https://image.tmdb.org/t/p/original/${movie.backDropPath}".isNotEmpty
                                            ? FadeInImage.assetNetwork(
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: "images/Animation - 1720202353247.gif",
                                            image:"https://image.tmdb.org/t/p/original/${movie.backDropPath}")
                                            : Image.asset("images/placeholder.png"),
                                        // child: Image.network(
                                        //   "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                                        //   height: 180,
                                        //   width: double.infinity,
                                        //   fit: BoxFit.cover,
                                        // ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0, // Set the movie name 100 pixels above the bottom
                                      left: 10,    // Add padding from the left for positioning
                                      right: 10,   // Padding from the right
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        color: Colors.black.withOpacity(0.5), // Slightly transparent background
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          movie.title, // Ensure this contains the movie name
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white, // White color for contrast
                                            fontSize: 16,        // Adjust size as needed
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
      },
    );
  }
}
