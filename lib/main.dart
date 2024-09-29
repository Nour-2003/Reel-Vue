import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/Screens/onBoarding.dart';
import 'package:movie_app/Services/API/api.dart';
import 'package:movie_app/Services/Database%20helper.dart';
import 'package:movie_app/Screens/Fav%20Screen.dart';
import 'package:movie_app/Screens/Movie%20Detail%20Screen.dart';
import 'package:movie_app/Services/Dio%20Helper.dart';
import 'package:movie_app/Shared/Shared.dart';
import 'package:movie_app/cubit/App%20States.dart';
import 'package:movie_app/cubit/Cubit.dart';
import 'package:sqflite/sqflite.dart';

import 'Model/movie_model.dart';
import 'Screens/HomePage.dart';
import 'Screens/SearchScreen.dart';

void main() {

  runApp(const MyApp());
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
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
    return BlocProvider(
        create: (context) => AppCubit()..createDatabase()..getPopularMovies()..getTopRatedMovies()..getUpcomingMovies(),
      child:BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){},
        builder: (context,state) {
          // print(AppCubit().topRatedMovies.length);
          // print(AppCubit().popularApiUrl.length);
          // print(AppCubit().upcomingMovies.length);
         return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Splash(),
          );
        }
      ),);
  }
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 4000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => onBoardingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Customize background color as needed
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Replace the SpinKitWave with your logo or any other animation widget
            Image.asset("images/movies.png",scale: 1,),
            SizedBox(height: 20.0),
            Text(
              'Reel Vue', // Customize your app name
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(fontSize: 35, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

