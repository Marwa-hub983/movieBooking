import 'package:equatable/equatable.dart';
import 'package:movieapp/shared/models/movie_model.dart';

class HomeFeed extends Equatable {
  const HomeFeed({
    required this.trending,
    required this.popular,
    required this.topRated,
    required this.nowPlaying,
  });

  final List<MovieModel> trending;
  final List<MovieModel> popular;
  final List<MovieModel> topRated;
  final List<MovieModel> nowPlaying;

  bool get isEmpty =>
      trending.isEmpty &&
      popular.isEmpty &&
      topRated.isEmpty &&
      nowPlaying.isEmpty;

  MovieModel? get featured =>
      trending.isNotEmpty ? trending.first : (popular.isNotEmpty ? popular.first : null);

  @override
  List<Object?> get props => [trending, popular, topRated, nowPlaying];
}
