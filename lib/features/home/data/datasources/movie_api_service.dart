import 'package:injectable/injectable.dart';
import 'package:movieapp/shared/models/movie_model.dart';
import 'package:movieapp/shared/models/result.dart';
import 'package:movieapp/shared/network/dio_client.dart';
import 'package:movieapp/shared/network/endpoints.dart';

/// Remote data source — talks to TMDB via [DioClient] only.
@lazySingleton
class MovieApiService {
  MovieApiService(this._client);

  final DioClient _client;

  Future<Result<MovieResponse>> getTrendingMovies({
    String timeWindow = 'week',
    int page = 1,
  }) {
    return _client.get(
      ApiEndpoints.trendingAllWeek,
      queryParameters: {'page': page},
      parser: _parsePage,
    );
  }

  Future<Result<MovieResponse>> getPopularMovies({int page = 1}) {
    return _client.get(
      ApiEndpoints.popularMovies,
      queryParameters: {'page': page},
      parser: _parsePage,
    );
  }

  Future<Result<MovieResponse>> getTopRatedMovies({int page = 1}) {
    return _client.get(
      ApiEndpoints.topRatedMovies,
      queryParameters: {'page': page},
      parser: _parsePage,
    );
  }

  Future<Result<MovieResponse>> getNowPlayingMovies({int page = 1}) {
    return _client.get(
      ApiEndpoints.nowPlayingMovies,
      queryParameters: {'page': page},
      parser: _parsePage,
    );
  }

  Future<Result<MovieResponse>> getUpcomingMovies({int page = 1}) {
    return _client.get(
      ApiEndpoints.upcomingMovies,
      queryParameters: {'page': page},
      parser: _parsePage,
    );
  }

  Future<Result<MovieResponse>> searchMovies({
    required String query,
    int page = 1,
  }) {
    return _client.get(
      ApiEndpoints.searchMovies,
      queryParameters: {
        'query': query,
        'page': page,
        'include_adult': false,
      },
      parser: _parsePage,
    );
  }

  static MovieResponse _parsePage(dynamic data) {
    return MovieResponse.fromJson(Map<String, dynamic>.from(data as Map));
  }
}
