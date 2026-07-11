import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movieapp/features/home/bloc/search_event.dart';
import 'package:movieapp/features/home/bloc/search_state.dart';
import 'package:movieapp/shared/domain/repositories/movie_repository.dart';
import 'package:movieapp/shared/models/result.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._repository) : super(const SearchInitial()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 400)),
    );
    on<SearchCleared>(_onCleared);
  }

  final MovieRepository _repository;

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchInitial());
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
    emit(const SearchInitial());
  }
}
