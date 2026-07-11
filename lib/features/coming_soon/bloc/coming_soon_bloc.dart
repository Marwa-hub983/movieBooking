import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movieapp/features/coming_soon/bloc/coming_soon_event.dart';
import 'package:movieapp/features/coming_soon/bloc/coming_soon_state.dart';
import 'package:movieapp/shared/domain/repositories/movie_repository.dart';
import 'package:movieapp/shared/models/movie_model.dart';
import 'package:movieapp/shared/models/result.dart';

@injectable
class ComingSoonBloc extends Bloc<ComingSoonEvent, ComingSoonState> {
  ComingSoonBloc(this._repository) : super(const ComingSoonInitial()) {
    on<ComingSoonStarted>(_onStarted);
    on<ComingSoonLoadMore>(_onLoadMore);
    on<ComingSoonRetried>(_onRetried);
  }

  final MovieRepository _repository;

  Future<void> _onStarted(
    ComingSoonStarted event,
    Emitter<ComingSoonState> emit,
  ) async {
    emit(const ComingSoonLoading());
    await _fetchPage(emit, page: 1, append: false);
  }

  Future<void> _onRetried(
    ComingSoonRetried event,
    Emitter<ComingSoonState> emit,
  ) async {
    emit(const ComingSoonLoading());
    await _fetchPage(emit, page: 1, append: false);
  }

  Future<void> _onLoadMore(
    ComingSoonLoadMore event,
    Emitter<ComingSoonState> emit,
  ) async {
    final current = state;
    if (current is! ComingSoonLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    await _fetchPage(emit, page: current.page + 1, append: true);
  }

  Future<void> _fetchPage(
    Emitter<ComingSoonState> emit, {
    required int page,
    required bool append,
  }) async {
    final result = await _repository.getUpcomingMovies(page: page);

    switch (result) {
      case Success(:final data):
        if (!append && data.isEmpty) {
          emit(const ComingSoonEmpty());
          return;
        }
        final previous = append && state is ComingSoonLoaded
            ? (state as ComingSoonLoaded).movies
            : <MovieModel>[];
        emit(
          ComingSoonLoaded(
            movies: [...previous, ...data.results],
            page: data.page,
            hasMore: data.hasMore,
          ),
        );
      case Error(:final failure):
        if (append && state is ComingSoonLoaded) {
          emit((state as ComingSoonLoaded).copyWith(isLoadingMore: false));
        } else {
          emit(ComingSoonError(failure));
        }
    }
  }
}
