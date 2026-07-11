import 'package:injectable/injectable.dart';
import 'package:movieapp/features/home/data/datasources/movie_api_service.dart';
import 'package:movieapp/shared/domain/repositories/movie_repository.dart';
import 'package:movieapp/shared/models/movie_model.dart';
import 'package:movieapp/shared/models/result.dart';

@LazySingleton(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(this._apiService);

  final MovieApiService _apiService;

  @override
  Future<Result<MovieResponse>> getTrendingMovies({int page = 1}) {
    return _apiService.getTrendingMovies(page: page);
  }

  @override
  Future<Result<MovieResponse>> getPopularMovies({int page = 1}) {
    return _apiService.getPopularMovies(page: page);
  }

  @override
  Future<Result<MovieResponse>> getTopRatedMovies({int page = 1}) {
    return _apiService.getTopRatedMovies(page: page);
  }

  @override
  Future<Result<MovieResponse>> getNowPlayingMovies({int page = 1}) {
    return _apiService.getNowPlayingMovies(page: page);
  }

  @override
  Future<Result<MovieResponse>> getUpcomingMovies({int page = 1}) {
    return _apiService.getUpcomingMovies(page: page);
  }

  @override
  Future<Result<MovieResponse>> searchMovies({
    required String query,
    int page = 1,
  }) {
    return _apiService.searchMovies(query: query, page: page);
  }
}
