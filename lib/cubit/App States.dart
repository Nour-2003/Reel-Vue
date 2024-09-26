abstract class AppStates{
}
class AppInitialState extends AppStates{
}
class CreateDatabase extends AppStates{
}
class InsertDatabase extends AppStates{
}
class GetDatabase extends AppStates{
}
class GetDatabaseLoadingState extends AppStates{
}
class UpdateDatabase extends AppStates{
}

class DeleteFavState extends AppStates{
}
class toggleSetFavState extends AppStates{
}
class toggleRemoveFavState extends AppStates{
}
class GetUpcomingMoviesDataState extends AppStates{
}
class GetUpcomingMoviesDataStateError extends AppStates{
  final String Error;
  GetUpcomingMoviesDataStateError({required this.Error});
}
class GetUpcomingMoviesDataStateLoading extends AppStates{

}
class GetTopRatedMoviesDataState extends AppStates{
}
class GetTopRatedMoviesDataStateError extends AppStates{
  final String Error;
  GetTopRatedMoviesDataStateError({required this.Error});
}
class GetTopRatedMoviesDataStateLoading extends AppStates{

}class GetPopularMoviesDataState extends AppStates{
}
class GetPopularMoviesDataStateError extends AppStates{
  final String Error;
  GetPopularMoviesDataStateError({required this.Error});
}
class GetPopularMoviesDataStateLoading extends AppStates{

}
class GetMovieDataStateLoading extends AppStates{
}
class GetMovieDataState extends AppStates{
}
class GetMovieDataStateError extends AppStates{
  final String Error;
  GetMovieDataStateError({required String this.Error});
}
class GetSearchDataStateLoading extends AppStates{

}
class GetSearchDataState extends AppStates{

}
class GetSearchDataStateError extends AppStates{
  final String Error;
  GetSearchDataStateError({required String this.Error});
}