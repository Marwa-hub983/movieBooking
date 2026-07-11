/// Relative TMDB API paths (base URL is in [ApiConstants]).
class ApiEndpoints {
  ApiEndpoints._();

  static const String popularMovies = '/movie/popular';
  static const String upcomingMovies = '/movie/upcoming';
  static const String nowPlayingMovies = '/movie/now_playing';
  static const String topRatedMovies = '/movie/top_rated';
  static const String searchMovies = '/search/movie';
  static const String trendingAllWeek = '/trending/all/week';
  static const String discoverMovies = '/discover/movie';

  static String trendingMovies({String timeWindow = 'week'}) =>
      '/trending/movie/$timeWindow';

  static String movieDetails(int movieId) => '/movie/$movieId';
}
