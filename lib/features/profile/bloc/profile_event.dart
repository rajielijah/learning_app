part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileUserChanged extends ProfileEvent {
  const ProfileUserChanged(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}

class ProfileLogoutRequested extends ProfileEvent {
  const ProfileLogoutRequested();
}

