import 'package:flutter/foundation.dart';

class Movie_model {
  late int id;
  late double populartiy;
  late String title;
  late String posterPath;
  late bool adult;
  late String backDropPath;
  late String overview;
  late String language;
  late double rating;
  late String date;
  late String trailerKey;
  final List<CastModel> cast;
  Movie_model({ required this.id,required this.populartiy,required this.title,required this.posterPath,required this.adult,required this.backDropPath,required this.overview,
  required this.language,required this.rating ,required this.date, this.trailerKey = '',required this.cast });
  factory Movie_model.fromMap(Map<String,dynamic> map)
  {
    return Movie_model(id:map['id'],populartiy: map['popularity'],title: map['title'], posterPath: map['poster_path'], adult: map['adult'], backDropPath: map['backdrop_path'], overview: map['overview'], language: map['original_language'], rating: map['vote_average'], date: map['release_date'], trailerKey: map['trailerKey'] ?? '',cast: map['cast']);
  }
  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'popularity':populartiy,
      'title':title,
      'poster_path':posterPath,
      'adult':adult,
      'backdrop_path':backDropPath,
      'overview':overview,
      'original_language':language,
      'vote_average':rating,
      'release_date':date,
      'Key': trailerKey
    };
  }
}
class CastModel {
  final int id;
  final String name;
  final String character;
  final String profilePath;

  CastModel({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
  });

  factory CastModel.fromMap(Map<String, dynamic> map) {
    return CastModel(
      id: map['id'],
      name: map['name'],
      character: map['character'],
      profilePath: map['profile_path'] ?? '', // Profile path may be null
    );
  }
  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'name':name,
      'character':character,
      'profile_path':profilePath,
    };
  }
}