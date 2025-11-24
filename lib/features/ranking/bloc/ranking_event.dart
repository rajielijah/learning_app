part of 'ranking_bloc.dart';

abstract class RankingEvent extends Equatable {
  const RankingEvent();

  @override
  List<Object?> get props => [];
}

class RankingStarted extends RankingEvent {
  const RankingStarted();
}

class RankingRefreshed extends RankingEvent {
  const RankingRefreshed();
}

