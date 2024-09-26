import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/cubit/App%20States.dart';

import '../cubit/Cubit.dart';
import 'Movie Detail Screen.dart';

class Searchscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var list = AppCubit.get(context).search;
          return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: Colors.black,
                title: Text(
                  'Search',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // Movie Name Search Field
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: AppCubit.get(context).searchController,
                          onFieldSubmitted: (value) {
                            AppCubit.get(context)
                                .GetSearchItems(value.toString());
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Search must not be empty";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter something',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(color: Colors.grey),
                            // Hint text color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        ConditionalBuilder(
                          condition: list.length > 0,
                          fallback: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          builder: (context) => GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: List.generate(list.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          movieDetailScreen(movie: list[index]),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width / 2,
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child:  "https://image.tmdb.org/t/p/original/${list[index].backDropPath}".isNotEmpty
                                          ? FadeInImage.assetNetwork(
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: "images/Animation - 1720202353247.gif",
                                          image:"https://image.tmdb.org/t/p/original/${list[index].backDropPath}")
                                      : Image.asset("images/placeholder.png"),
                                        // child: Image.network(
                                        //   "https://image.tmdb.org/t/p/original/${list[index].backDropPath}",
                                        //   height: 200,
                                        //   width: double.infinity,
                                        //   fit: BoxFit.cover,
                                        // ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      // Set the movie name 100 pixels above the bottom
                                      left: 0,
                                      // Add padding from the left for positioning
                                      right: 0,
                                      // Padding from the right
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        color: Colors.black.withOpacity(0.5),
                                        // Slightly transparent background
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          list[index].title,
                                          // Ensure this contains the movie name
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
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
