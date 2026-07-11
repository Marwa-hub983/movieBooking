import 'package:equatable/equatable.dart';
import 'package:movieapp/shared/models/failure.dart';
import 'package:movieapp/shared/models/movie_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  const SearchLoaded(this.movies, {required this.query});

  final List<MovieModel> movies;
  final String query;

  @override
  List<Object?> get props => [movies, query];
}

class SearchEmpty extends SearchState {
  const SearchEmpty({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  const SearchError(this.failure, {required this.query});

  final Failure failure;
  final String query;

  @override
  List<Object?> get props => [failure, query];
}
