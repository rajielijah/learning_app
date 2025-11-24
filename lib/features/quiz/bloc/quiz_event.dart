part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class QuizRequested extends QuizEvent {
  const QuizRequested(this.categoryId);

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}

class QuizCountdownTicked extends QuizEvent {
  const QuizCountdownTicked(this.value);

  final int value;

  @override
  List<Object?> get props => [value];
}

class QuizCountdownCompleted extends QuizEvent {
  const QuizCountdownCompleted();
}

class QuizTimerTicked extends QuizEvent {
  const QuizTimerTicked(this.remaining);

  final int remaining;

  @override
  List<Object?> get props => [remaining];
}

class QuizAnswerSelected extends QuizEvent {
  const QuizAnswerSelected(this.answer);

  final String answer;

  @override
  List<Object?> get props => [answer];
}

class QuizAdvanceRequested extends QuizEvent {
  const QuizAdvanceRequested();
}

class QuizCleared extends QuizEvent {
  const QuizCleared();
}

class QuizConnectivityChanged extends QuizEvent {
  const QuizConnectivityChanged(this.isOnline);

  final bool isOnline;

  @override
  List<Object?> get props => [isOnline];
}

