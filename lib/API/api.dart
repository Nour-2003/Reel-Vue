import 'dart:convert';

import 'package:movie_app/API/Constants.dart';
import 'package:movie_app/Model/movie_model.dart';
import 'package:http/http.dart' as http;

class API {
  late String upComingApiUrl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  late String popularApiUrl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  late String topRatedApiUrl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";

  Future<List<Movie_model>> getUpcomingMovies() async {
    final response =  await http.get(Uri.parse(upComingApiUrl));
    if(response.statusCode == 200)
      {
        final List<dynamic>  data = json.decode(response.body)['results'];
        List<Movie_model> Movies = data.map((movie) => Movie_model.fromMap(movie)).toList();
        return Movies;
      }else{
      throw Exception('Failed to load Upcoming movies');
    }
  }

  Future<List<Movie_model>> getTopRatedMovies() async {
    final response =  await http.get(Uri.parse(topRatedApiUrl));
    if(response.statusCode == 200)
    {
      final List<dynamic>  data = json.decode(response.body)['results'];
      List<Movie_model> Movies = data.map((movie) => Movie_model.fromMap(movie)).toList();
      return Movies;
    }else{
      throw Exception('Failed to load TopRated movies');
    }
  }

  Future<List<Movie_model>> getPopularMovies() async {
    final response =  await http.get(Uri.parse(popularApiUrl));
    if(response.statusCode == 200)
    {
      final List<dynamic>  data = json.decode(response.body)['results'];
      List<Movie_model> Movies = data.map((movie) => Movie_model.fromMap(movie)).toList();
      return Movies;
    }else{
      throw Exception('Failed to load Popular movies');
    }
  }
}
