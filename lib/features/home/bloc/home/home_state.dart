import 'package:equatable/equatable.dart';
import 'package:movieapp/features/home/domain/models/home_feed.dart';
import 'package:movieapp/shared/models/failure.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  const HomeLoaded(this.feed, {this.profileName = 'User'});

  final HomeFeed feed;
  final String profileName;

  @override
  List<Object?> get props => [feed, profileName];
}

class HomeEmpty extends HomeState {
  const HomeEmpty({this.profileName = 'User'});

  final String profileName;

  @override
  List<Object?> get props => [profileName];
}

class HomeError extends HomeState {
  const HomeError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
