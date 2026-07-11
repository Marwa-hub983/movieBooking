import 'package:equatable/equatable.dart';
import 'package:movieapp/shared/config/api_constants.dart';

/// Strongly typed movie model (no raw maps in UI).
class MovieModel extends Equatable {
  const MovieModel({
    required this.id,
    required this.title,
    this.overview = '',
    this.posterPath,
    this.backdropPath,
    this.voteAverage = 0,
    this.releaseDate,
    this.popularity = 0,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String? releaseDate;
  final double popularity;

  String get posterUrl => ApiConstants.posterUrl(posterPath);
  String get backdropUrl =>
      ApiConstants.backdropUrl(backdropPath ?? posterPath);

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int? ?? 0,
      title: (json['title'] ?? json['name'] ?? '') as String,
      overview: (json['overview'] ?? '') as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      releaseDate: (json['release_date'] ?? json['first_air_date']) as String?,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'overview': overview,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'vote_average': voteAverage,
        'release_date': releaseDate,
        'popularity': popularity,
      };

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        releaseDate,
        popularity,
      ];
}

/// Paginated TMDB list response.
class MovieResponse extends Equatable {
  const MovieResponse({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    required this.results,
  });

  final int page;
  final int totalPages;
  final int totalResults;
  final List<MovieModel> results;

  bool get isEmpty => results.isEmpty;
  bool get hasMore => page < totalPages;

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    final list = json['results'] as List<dynamic>? ?? [];
    return MovieResponse(
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalResults: json['total_results'] as int? ?? 0,
      results: list
          .whereType<Map>()
          .map((e) => MovieModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [page, totalPages, totalResults, results];
}
