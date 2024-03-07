import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/Database%20helper.dart';

import 'Model/movie_model.dart';

class fav_screen extends StatefulWidget {
  @override
  State<fav_screen> createState() => _fav_screenState();
}

class _fav_screenState extends State<fav_screen> {
  @override
  void initState() {
    super.initState();
    _loadFavorites();
    Database_helper.instance.favoriteNotifier.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    Database_helper.instance.favoriteNotifier
        .removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) {
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    movies =
        await Database_helper.instance.getDataFromDatabase(Database_helper.db);
    if (mounted) {
      setState(() {
        movies = movies;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text(
          "My List ",
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 10,left: 7),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    //margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child:Image.network(
                        "https://image.tmdb.org/t/p/original/${movies[index]['image']}",
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,) ,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movies[index]['title'],
                          //overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await Database_helper.instance
                        .deleteFromDatabase(movies[index]['id']);
                    _loadFavorites();
                  },
                ),
              ],
            )),
      ),
    );
  }
}
// ListTile(
// leading: Image.network("https://image.tmdb.org/t/p/original/${movies[index]['image']}",),
// title: Text(movies[index]['title'],style: GoogleFonts.montserrat(
// fontSize: 20,
// fontWeight: FontWeight.bold,
// fontStyle: FontStyle.italic,
// color: Colors.white,
// ),),
// trailing: IconButton(
// icon: Icon(Icons.delete,color: Colors.white,),
// onPressed: () async{
// await Database_helper.instance.deleteFromDatabase(movies[index]['id']);
// _loadFavorites();
// },
// ),),${movies[index]['image']}
