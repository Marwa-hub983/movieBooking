import 'package:equatable/equatable.dart';
import 'package:movieapp/shared/models/failure.dart';
import 'package:movieapp/shared/models/movie_model.dart';

abstract class ComingSoonState extends Equatable {
  const ComingSoonState();

  @override
  List<Object?> get props => [];
}

class ComingSoonInitial extends ComingSoonState {
  const ComingSoonInitial();
}

class ComingSoonLoading extends ComingSoonState {
  const ComingSoonLoading();
}

class ComingSoonLoaded extends ComingSoonState {
  const ComingSoonLoaded({
    required this.movies,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  final List<MovieModel> movies;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  ComingSoonLoaded copyWith({
    List<MovieModel>? movies,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ComingSoonLoaded(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [movies, page, hasMore, isLoadingMore];
}

class ComingSoonEmpty extends ComingSoonState {
  const ComingSoonEmpty();
}

class ComingSoonError extends ComingSoonState {
  const ComingSoonError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
