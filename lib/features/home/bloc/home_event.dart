part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class HomeProgressUpdated extends HomeEvent {
  const HomeProgressUpdated(this.result);

  final QuizResult result;

  @override
  List<Object?> get props => [result];
}

class HomeConnectivityChanged extends HomeEvent {
  const HomeConnectivityChanged(this.isOnline);

  final bool isOnline;

  @override
  List<Object?> get props => [isOnline];
}

class HomeSyncRequested extends HomeEvent {
  const HomeSyncRequested();
}

class HomeProfileStreamed extends HomeEvent {
  const HomeProfileStreamed(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}

