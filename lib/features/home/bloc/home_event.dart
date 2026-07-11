import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted({this.profileName = 'User'});

  final String profileName;

  @override
  List<Object?> get props => [profileName];
}

class HomeRetried extends HomeEvent {
  const HomeRetried();
}
