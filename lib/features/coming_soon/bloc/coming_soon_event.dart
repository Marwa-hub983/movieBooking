import 'package:equatable/equatable.dart';

abstract class ComingSoonEvent extends Equatable {
  const ComingSoonEvent();

  @override
  List<Object?> get props => [];
}

class ComingSoonStarted extends ComingSoonEvent {
  const ComingSoonStarted();
}

class ComingSoonLoadMore extends ComingSoonEvent {
  const ComingSoonLoadMore();
}

class ComingSoonRetried extends ComingSoonEvent {
  const ComingSoonRetried();
}
