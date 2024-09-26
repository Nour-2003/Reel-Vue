import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/Services/Database%20helper.dart';
import 'package:movie_app/Screens/Fav%20Screen.dart';
import 'package:movie_app/Model/movie_model.dart';
import 'package:movie_app/cubit/App%20States.dart';
import 'package:movie_app/cubit/Cubit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Webview.dart';

class movieDetailScreen extends StatelessWidget {
  late Movie_model movie;
  movieDetailScreen({required this.movie});
  @override
  // int randomInt = movie.rating/2 as int;
  List<Widget> star() {
    List<Widget> starList = [];
    int realNumber = (movie.rating / 2).floor();
    int partNumber = (((movie.rating / 2) - realNumber) * 10).ceil();
    for (int i = 0; i < 6; i++) {
      if (i < realNumber) {
        starList.add(Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
        ));
      } else if (i == realNumber) {
      } else {
        starList.add(Icon(
          Icons.star,
          color: Colors.grey,
          size: 20,
        ));
      }
    }
    return starList;
  }

  // Future<void> _checkFavoriteStatus() async {
  //   final isFav = await Database_helper.instance.isFavorite(movie.id);
  //   print(isFav);
  //   setState(() {
  //     isLoveActivated = isFav!;
  //   });
  // }

  // Future<void> _toggleFavorite() async {
  //   if (isLoveActivated) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(' Removed successfully'),
  //       ),
  //     );
  //     Database_helper.instance.deleteFromDatabase(movie.id);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(' Added successfully'),
  //       ),
  //     );
  //     await Database_helper.instance.insertToDatabase(
  //         id: movie.id, title: movie.title, image: movie.backDropPath);
  //   }
  //   setState(() {
  //     isLoveActivated = !isLoveActivated;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener:  (context,state){},
      builder: (context,state){
        return Scaffold(
          backgroundColor: Colors.black,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFFD04848),
            // backgroundColor: isLoveActivated ?Colors.white :Colors.red,
            child: Icon(
              AppCubit.get(context).isFavorite(movie.id) ?  Icons.remove_circle:Icons.favorite,
              color: Colors.black,
              size: 35,
            ),
            onPressed: () {
              AppCubit.get(context).toggleFavorite(AppCubit.get(context).isFavorite(movie.id),context, movie);
              // setState(() {
              //   _toggleFavorite();
              // });
            },
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: <Widget>[
                    SizedBox(
                      height: 450,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                        child: Image.network(
                          "https://image.tmdb.org/t/p/original/${movie.backDropPath}",
                          scale: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 35, horizontal: 15),
                      child: Container(
                        child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15)),
                            child: IconButton(
                              color: Colors.white,
                              icon: Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Text(
                    "Title :",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.amber,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 5),
                  child: Text(
                    movie.title + ' (' + movie.date.substring(0, 4) + ')',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: star(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20, bottom: 7),
                  child: Text(
                    "Storyline :",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.amber,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    movie.overview,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding:
                    EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Popularity",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              movie.populartiy.floor().toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        Container(
                          height: 35,
                          child: VerticalDivider(
                            color: Colors.amber,
                            thickness: 2,
                            width: 11,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "Language",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              movie.language.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        Container(
                          height: 35,
                          child: VerticalDivider(
                            color: Colors.amber,
                            thickness: 2,
                            width: 10,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "Rating",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              movie.rating.floor().toString() + '/10',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20, bottom: 7),
                  child: Text(
                    "Movie Cast :",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.amber,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 20, bottom: 7),
                  child: SizedBox(
                    height: 100,
                    child: ListView.separated(
                      itemCount: movie.cast.length,
                      //  shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 12,
                        );
                      },
                      itemBuilder: (context, index) {
                        final String profilePath = movie.cast[index].profilePath;
                        return Container(
                          width: 80,
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 35,
                                backgroundImage: getPic(profilePath),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                movie.cast[index].name,
                                style: TextStyle(color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(8),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFFD04848)), // Background color
                      minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                    ),
                    child: Text(
                      "Watch Trailer",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white),
                    ),
                    onPressed: () {
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => WebviewScreen(url: 'https://www.youtube.com/watch?v=${movie.trailerKey}',)));
                      launch('https://www.youtube.com/watch?v=${movie.trailerKey}');
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      } ,
    );
  }
}



ImageProvider<Object> getPic(String profilePath)
{
  ImageProvider<Object> img;
  profilePath != ""
      ? img = NetworkImage(
      "https://image.tmdb.org/t/p/w200$profilePath")
      : img = AssetImage("images/Actor2.jpeg");
  return img;
}