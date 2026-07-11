import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:movieapp/features/home/bloc/home_event.dart';
import 'package:movieapp/features/home/bloc/home_state.dart';
import 'package:movieapp/features/home/domain/models/home_feed.dart';
import 'package:movieapp/shared/domain/repositories/movie_repository.dart';
import 'package:movieapp/shared/models/movie_model.dart';
import 'package:movieapp/shared/models/result.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(const HomeInitial()) {
    on<HomeStarted>(_onStarted);
    on<HomeRetried>(_onRetried);
  }

  final MovieRepository _repository;
  String _profileName = 'User';

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    _profileName = event.profileName;
    await _load(emit);
  }

  Future<void> _onRetried(HomeRetried event, Emitter<HomeState> emit) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<HomeState> emit) async {
    emit(const HomeLoading());

    final results = await Future.wait([
      _repository.getTrendingMovies(),
      _repository.getPopularMovies(),
      _repository.getTopRatedMovies(),
      _repository.getNowPlayingMovies(),
    ]);

    for (final result in results) {
      if (result case Error(:final failure)) {
        emit(HomeError(failure));
        return;
      }
    }

    List<MovieModel> movies(Result<MovieResponse> r) =>
        (r as Success<MovieResponse>).data.results;

    final feed = HomeFeed(
      trending: movies(results[0]),
      popular: movies(results[1]),
      topRated: movies(results[2]),
      nowPlaying: movies(results[3]),
    );

    if (feed.isEmpty) {
      emit(HomeEmpty(profileName: _profileName));
    } else {
      emit(HomeLoaded(feed, profileName: _profileName));
    }
  }
}
