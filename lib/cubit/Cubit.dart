import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/Model/movie_model.dart';
import 'package:movie_app/Services/Dio%20Helper.dart';
import 'package:sqflite/sqflite.dart';

import '../Services/API/Constants.dart';
import 'App States.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  List<Map> Favs = [];
  static Database? db;
  late String upComingApiUrl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  late String popularApiUrl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  late String topRatedApiUrl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";
  List<Movie_model> movies = [];
  List<Movie_model> upcomingMovies = [];
  List<Movie_model> topRatedMovies = [];
  List<Movie_model> popularMovies = [];

  // void getMovies(String apiUrl) {
  //   if (movies.isEmpty) {
  //     emit(GetMovieDataStateLoading());
  //     DioHelper.getData(url: apiUrl, query: {
  //       'api_key': 'your_api_key_here',
  //     }).then((value) async {
  //       final List<dynamic> data = value.data['results'];
  //       for (var movieData in data) {
  //         final int movieId = movieData['id'];
  //         final trailerKey = await getTrailerKey(movieId);
  //         final cast = await getMovieCast(movieId);
  //         final movie = Movie_model.fromMap({
  //           ...movieData,
  //           'trailerKey': trailerKey,
  //           'cast': cast,
  //         });
  //         movies.add(movie);
  //       }
  //       emit(GetMovieDataState());
  //     }).catchError((error) {
  //       emit(GetMovieDataStateError(Error: error.toString()));
  //     });
  //   } else {
  //     emit(GetMovieDataState());
  //   }
  // }

  Future<String> getTrailerKey(int movieId) async {
    final url = "3/movie/$movieId/videos";
    final response = await DioHelper.getData(url: url,query: {
      "api_key":"$apiKey",
    });

    if (response.statusCode == 200) {
      final List<dynamic> videos = response.data['results'];
      if (videos.isNotEmpty) {
        return videos[0]['key'];
      }
    }

    return ''; // Return empty string if no trailer key is found
  }

  Future<List<CastModel>> getMovieCast(int movieId) async {
    final apiUrl = "3/movie/$movieId/credits";
    final response = await DioHelper.getData(url: apiUrl,query: {
    "api_key":"$apiKey",
    });

    if (response.statusCode == 200) {
      final List<dynamic> castData = response.data['cast'];
      List<CastModel> cast = castData.map((cast) => CastModel.fromMap(cast)).toList();
      return cast;
    } else {
      throw Exception('Failed to load movie cast');
    }
  }

  void getUpcomingMovies() {
    emit(GetUpcomingMoviesDataStateLoading());
    DioHelper.getData(url: "3/movie/upcoming", query: {
      "api_key":"f5aa37718545ca90afc97b445ad6339a",
    }).then((value) async {
      final List<dynamic> data = value.data['results'];
      for (var movieData in data) {
        final int movieId = movieData['id'];
        final trailerKey = await getTrailerKey(movieId);
        final cast = await getMovieCast(movieId);
        final movie = Movie_model.fromMap({
          ...movieData,
          'trailerKey': trailerKey,
          'cast': cast,
        });
        upcomingMovies.add(movie);
      }
      emit(GetUpcomingMoviesDataState());
    }).catchError((error) {
      emit(GetUpcomingMoviesDataStateError(Error: error.toString()));
    });
  }

  void getTopRatedMovies() {
    emit(GetTopRatedMoviesDataStateLoading());
    DioHelper.getData(url: "3/movie/top_rated", query: {
      "api_key":"f5aa37718545ca90afc97b445ad6339a",
    }).then((value) async {
      final List<dynamic> data = value.data['results'];
      for (var movieData in data) {
        final int movieId = movieData['id'];
        final trailerKey = await getTrailerKey(movieId);
        final cast = await getMovieCast(movieId);
        final movie = Movie_model.fromMap({
          ...movieData,
          'trailerKey': trailerKey,
          'cast': cast,
        });
        topRatedMovies.add(movie);
      }
      emit(GetTopRatedMoviesDataState());
    }).catchError((error) {
      emit(GetTopRatedMoviesDataStateError(Error: error.toString()));
    });
  }

  void getPopularMovies() {
    emit(GetPopularMoviesDataStateLoading());
    DioHelper.getData(url: "3/movie/popular", query: {
      "api_key":"f5aa37718545ca90afc97b445ad6339a",
    }).then((value) async {
      final List<dynamic> data = value.data['results'];
      for (var movieData in data) {
        final int movieId = movieData['id'];
        final trailerKey = await getTrailerKey(movieId);
        final cast = await getMovieCast(movieId);
        final movie = Movie_model.fromMap({
          ...movieData,
          'trailerKey': trailerKey,
          'cast': cast,
        });
        popularMovies.add(movie);
      }
      emit(GetPopularMoviesDataState());
    }).catchError((error) {
      emit(GetPopularMoviesDataStateError(Error: error.toString()));
    });
  }
  TextEditingController searchController = TextEditingController();
  List<dynamic> search =[];
  void GetSearchItems(String value)
  {

    emit(GetSearchDataStateLoading());
    search = [];
    DioHelper.getData(url: "3/search/movie", query: {
      "query": value,
      "api_key": "f5aa37718545ca90afc97b445ad6339a"
    }).then((value) async {
      final List<dynamic> data = value.data['results'];
      for (var movieData in data) {
        final int movieId = movieData['id'];
        final trailerKey = await getTrailerKey(movieId);
        final cast = await getMovieCast(movieId);
        final movie = Movie_model.fromMap({
          ...movieData,
          'trailerKey': trailerKey,
          'cast': cast,
        });
        search.add(movie);
        print(search);
      }
      emit(GetSearchDataState());
    }).catchError((error) {
      emit(GetSearchDataStateError(Error:error.toString()));
    });
  }
  // static final Database_helper instance = Database_helper._init();
  //
  //
  // Database_helper._init();
  // final _favoriteNotifier = ValueNotifier<List<Map>>([]);
  // ValueListenable<List<Map>> get favoriteNotifier =>
  //     _favoriteNotifier;

  void createDatabase()  {
    openDatabase(
      'fav.db',
      onCreate: (db, version)  {
        print("Database is created");
         db.execute(
            '  CREATE TABLE favs (id INTEGER PRIMARY KEY, title TEXT ,image TEXT )')
            .then((value) {
          print("table is created");
        }).catchError((error) {
          print("Error when creating table");
        });
      },
      onOpen: (db) {
        getDataFromDatabase(db);
        print("Database is opened");
      },
      version: 1,
    ).then((value){
      db = value;
      emit(CreateDatabase());
    });
  }
   insertToDatabase({required int id,required String title,required String image}) async {
    await db?.transaction((txn) async{
      try {
        txn.rawInsert(
            'INSERT INTO favs(id,title,image) VALUES("$id","$title","$image")');
        emit(InsertDatabase());
        getDataFromDatabase(db);
        print('Inserted Successfully');
      } catch (error) {
        print('Error inserting into database: $error');
      }
    });
  }
  bool isFavorite(int productId)  {
    final favoriteList = Favs;
    return favoriteList.any((element) => element['id'] == productId);
  }

  void getDataFromDatabase(database){
    emit(GetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM favs').then((value) {
      Favs = value;
      emit(GetDatabase());
    });
    // _favoriteNotifier.value = movies;

  }
  void deleteFromDatabase(int id) async{

    try {
      await db?.rawDelete('DELETE FROM favs WHERE id = $id');
      print('Deleted Successfully');
      getDataFromDatabase(db);
      emit(DeleteFavState());
    } catch (e) {
      print('Error deleting item: $e');
    }
  }
void toggleFavorite(isLoveActivated,context,movie){
  if (isLoveActivated) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(' Removed successfully'),
      ),
    );
    AppCubit.get(context).deleteFromDatabase(movie.id);
    emit(toggleSetFavState());
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(' Added successfully'),
      ),
    );
    AppCubit.get(context).insertToDatabase(
        id: movie.id, title: movie.title, image: movie.backDropPath);
  }
    emit(toggleRemoveFavState());
}
}