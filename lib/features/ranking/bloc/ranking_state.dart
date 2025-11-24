part of 'ranking_bloc.dart';

class RankingState extends Equatable {
  const RankingState({
    this.users = const [],
    this.highlightUserId,
    this.loading = false,
    this.error,
  });

  final List<RankingUser> users;
  final String? highlightUserId;
  final bool loading;
  final String? error;

  RankingState copyWith({
    List<RankingUser>? users,
    String? highlightUserId,
    bool? loading,
    String? error,
  }) {
    return RankingState(
      users: users ?? this.users,
      highlightUserId: highlightUserId ?? this.highlightUserId,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [users, highlightUserId, loading, error];
}

