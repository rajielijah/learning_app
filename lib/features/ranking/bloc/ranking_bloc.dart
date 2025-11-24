import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_learning_app/core/models/ranking_user.dart';
import 'package:quiz_learning_app/core/session/session_cubit.dart';
import 'package:quiz_learning_app/features/ranking/repositories/ranking_repository.dart';

part 'ranking_event.dart';
part 'ranking_state.dart';

class RankingBloc extends Bloc<RankingEvent, RankingState> {
  RankingBloc({
    required RankingRepository rankingRepository,
    required SessionCubit sessionCubit,
  })  : _repository = rankingRepository,
        _sessionCubit = sessionCubit,
        super(const RankingState()) {
    on<RankingStarted>(_onStarted);
    on<RankingRefreshed>(_onRefreshed);
  }

  final RankingRepository _repository;
  final SessionCubit _sessionCubit;

  Future<void> _onStarted(RankingStarted event, Emitter<RankingState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final users = await _repository.loadRankings();
      emit(
        state.copyWith(
          loading: false,
          users: users,
          highlightUserId: _sessionCubit.state.session?.userId,
        ),
      );
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  Future<void> _onRefreshed(RankingRefreshed event, Emitter<RankingState> emit) async {
    add(const RankingStarted());
  }
}

