part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    required this.categories,
    required this.progress,
    this.profile,
    this.hasSession = false,
    this.isOffline = false,
    this.isSyncing = false,
    this.loading = false,
    this.error,
  });

  final List<QuizCategory> categories;
  final Map<String, QuizResult> progress;
  final UserProfile? profile;
  final bool hasSession;
  final bool isOffline;
  final bool isSyncing;
  final bool loading;
  final String? error;

  factory HomeState.initial() {
    return HomeState(
      categories: CategoryConfig.categories,
      progress: <String, QuizResult>{},
    );
  }

  HomeState copyWith({
    List<QuizCategory>? categories,
    Map<String, QuizResult>? progress,
    UserProfile? profile,
    bool? hasSession,
    bool? isOffline,
    bool? isSyncing,
    bool? loading,
    String? error,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      progress: progress ?? this.progress,
      profile: profile ?? this.profile,
      hasSession: hasSession ?? this.hasSession,
      isOffline: isOffline ?? this.isOffline,
      isSyncing: isSyncing ?? this.isSyncing,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [categories, progress, profile, hasSession, isOffline, isSyncing, loading, error];
}

