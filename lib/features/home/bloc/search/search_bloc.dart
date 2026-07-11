import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movieapp/features/home/bloc/search/search_event.dart';
import 'package:movieapp/features/home/bloc/search/search_state.dart';
import 'package:movieapp/shared/domain/repositories/movie_repository.dart';
import 'package:movieapp/shared/models/movie_model.dart';
import 'package:movieapp/shared/models/result.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._repository) : super(const SearchInitial()) {
    on<SearchStarted>(_onStarted);
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 400)),
    );
    on<SearchCleared>(_onCleared);
  }

  final MovieRepository _repository;
  List<MovieModel> _topSearches = const [];

  Future<void> _onStarted(
    SearchStarted event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchLoading());
    final result = await _repository.getTrendingMovies();

    switch (result) {
      case Success(:final data):
        _topSearches = data.results;
        if (_topSearches.isEmpty) {
          emit(const SearchEmpty(query: ''));
        } else {
          emit(SearchTopLoaded(_topSearches));
        }
      case Error(:final failure):
        emit(SearchError(failure));
    }
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(
        _topSearches.isEmpty
            ? const SearchInitial()
            : SearchTopLoaded(_topSearches),
      );
      return;
    }

    emit(const SearchLoading());
    final result = await _repository.searchMovies(query: query);

    switch (result) {
      case Success(:final data):
        if (data.isEmpty) {
          emit(SearchEmpty(query: query));
        } else {
          emit(SearchLoaded(data.results, query: query));
        }
      case Error(:final failure):
        emit(SearchError(failure, query: query));
    }
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(
      _topSearches.isEmpty
          ? const SearchInitial()
          : SearchTopLoaded(_topSearches),
    );
  }
}
