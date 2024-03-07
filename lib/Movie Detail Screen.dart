import 'dart:math';
import 'package:flutter/material.dart';
import 'package:movie_app/Database%20helper.dart';
import 'package:movie_app/Fav%20Screen.dart';
import 'package:movie_app/Model/movie_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_fonts/google_fonts.dart';
class movieDetailScreen extends StatefulWidget {
  late Movie_model movie;

  movieDetailScreen({required this.movie});
  @override
  State<movieDetailScreen> createState() => _movieDetailScreenState();
}

class _movieDetailScreenState extends State<movieDetailScreen> {
  late Movie_model movie;
  bool isLoveActivated = false;
  late Database db;
  @override
   // int randomInt = movie.rating/2 as int;
    List<Widget> star() {
      List<Widget> starList = [];
      int realNumber = (movie.rating/2).floor();
      int partNumber = (((movie.rating/2) - realNumber) * 10).ceil();
      for (int i = 0; i < 6; i++) {
        if (i < realNumber) {
          starList.add(Icon(Icons.star, color: Colors.amber, size: 20,));
        }
        else if (i == realNumber) {

        }
        else {
          starList.add(Icon(Icons.star, color: Colors.grey, size: 20,));
        }
      }
      return starList;
    }
  Future<void> _checkFavoriteStatus() async {
    final isFav = await Database_helper.instance.isFavorite(movie.id);
    print(isFav);
    setState(() {
      isLoveActivated = isFav!;
    });
  }
    Future<void> _toggleFavorite() async {
      if (isLoveActivated) {
        Database_helper.instance.deleteFromDatabase(movie.id);
      } else {
        await Database_helper.instance.insertToDatabase(
           id: movie.id, title: movie.title, image: movie.backDropPath);
      }
      setState(() {
        isLoveActivated = !isLoveActivated;
      });
    }
    void initState() {
      super.initState();
      movie = widget.movie;
      _checkFavoriteStatus();

    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color(0xFF242427),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFD04848),
          // backgroundColor: isLoveActivated ?Colors.white :Colors.red,
          child: Icon(
            isLoveActivated ? Icons.remove_circle : Icons.favorite,
            color: Color(0xFF242427),
            size: 35,
          ),
          onPressed: () {
            setState(() {
              _toggleFavorite();
            });
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
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
                            color: Color(0xFF242427),
                              borderRadius: BorderRadius.circular(15)),
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.arrow_back, size: 30,
                              color: Colors.white,),
                            onPressed: () {
                               Navigator.of(context).pop();
                            },
                          )),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 20, right: 20, left: 20),
                child: Text(
                  "Title :",
                  style:GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.amber,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20,top: 5),
                child: Text(movie.title+' (' + movie.date.substring(0,4) + ')', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children:
                  star(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 20, bottom: 7),
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
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white
                  ),),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: 10, right: 20, left: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text("Popularity", style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.amber,
                          ),),
                          SizedBox(height: 10,),
                          Text(movie.populartiy.floor().toString(), style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),)
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
                          Text("Language", style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.amber,
                          ),),
                          SizedBox(height: 10,),
                          Text(movie.language.toUpperCase(), style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),)
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
                          Text("Rating", style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.amber,
                          ),),
                          SizedBox(height: 10,),
                          Text(movie.rating.floor().toString()+'/10', style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),)
                        ],
                      ),
                    ],
                  )
              ),
              SizedBox(height: 13,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(8),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFFD04848)), // Background color
                    minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
                  ),
                  child: Text("Watch Now", style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15
                  ),),
                  onPressed: () {
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

