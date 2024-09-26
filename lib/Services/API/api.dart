import 'dart:convert';
import 'package:movie_app/Model/movie_model.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/Services/API/Constants.dart';

class API {
  late String upComingApiUrl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  late String popularApiUrl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  late String topRatedApiUrl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";


  // Future<List<Movie_model>> getUpcomingMovies() async {
  //   final response =  await http.get(Uri.parse(upComingApiUrl));
  //   if(response.statusCode == 200)
  //     {
  //       final List<dynamic>  data = json.decode(response.body)['results'];
  //       List<Movie_model> Movies = data.map((movie) => Movie_model.fromMap(movie)).toList();
  //       return Movies;
  //     }else{
  //     throw Exception('Failed to load Upcoming movies');
  //   }
  // }
  //
  // Future<List<Movie_model>> getTopRatedMovies() async {
  //   final response =  await http.get(Uri.parse(topRatedApiUrl));
  //   if(response.statusCode == 200)
  //   {
  //     final List<dynamic>  data = json.decode(response.body)['results'];
  //     List<Movie_model> Movies = data.map((movie) => Movie_model.fromMap(movie)).toList();
  //     return Movies;
  //   }else{
  //     throw Exception('Failed to load TopRated movies');
  //   }
  // }
  //
  // Future<List<Movie_model>> getPopularMovies() async {
  //   final response =  await http.get(Uri.parse(popularApiUrl));
  //   if(response.statusCode == 200)
  //   {
  //     final List<dynamic>  data = json.decode(response.body)['results'];
  //     List<Movie_model> Movies = data.map((movie) => Movie_model.fromMap(movie)).toList();
  //     return Movies;
  //   }else{
  //     throw Exception('Failed to load Popular movies');
  //   }
  // }
  Future<List<Movie_model>> getMovies(String apiUrl) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie_model> movies = [];

      for (var movieData in data) {
        final int movieId = movieData['id'];

        // Fetch trailer key for each movie
        final trailerKey = await getTrailerKey(movieId);

        // Fetch cast for each movie
        final cast = await getMovieCast(movieId);
        // Create MovieModel instance with trailer key and cast
        final movie = Movie_model.fromMap({
          ...movieData,
          'trailerKey': trailerKey,
          'cast': cast,
        });

        movies.add(movie);

      }

      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<CastModel>> getMovieCast(int movieId) async {
    final apiUrl = "https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> castData = data['cast'];

      List<CastModel> cast = castData.map((cast) => CastModel.fromMap(cast)).toList();
      return cast;
    } else {
      throw Exception('Failed to load movie cast');
    }
  }

  Future<String> getTrailerKey(int movieId) async {
    final url = "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> videos = json.decode(response.body)['results'];
      if (videos.isNotEmpty) {
        return videos[0]['key'];
      }
    }

    return ''; // Return empty string if no trailer key is found
  }


  Future<List<Movie_model>> getUpcomingMovies() async {
    const apiUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
    return getMovies(apiUrl);
  }

  Future<List<Movie_model>> getTopRatedMovies() async {
    const apiUrl = "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";
    return getMovies(apiUrl);
  }

  Future<List<Movie_model>> getPopularMovies() async {
    const apiUrl = "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
    return getMovies(apiUrl);
  }
}
