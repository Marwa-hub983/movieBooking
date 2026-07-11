import 'package:movieapp/shared/models/movie_model.dart';
import 'package:movieapp/shared/models/result.dart';

/// Contract for movie data. Never exposes Dio.
abstract class MovieRepository {
  Future<Result<MovieResponse>> getTrendingMovies({int page = 1});

  Future<Result<MovieResponse>> getPopularMovies({int page = 1});

  Future<Result<MovieResponse>> getTopRatedMovies({int page = 1});

  Future<Result<MovieResponse>> getNowPlayingMovies({int page = 1});

  Future<Result<MovieResponse>> getUpcomingMovies({int page = 1});

  Future<Result<MovieResponse>> searchMovies({
    required String query,
    int page = 1,
  });
}
