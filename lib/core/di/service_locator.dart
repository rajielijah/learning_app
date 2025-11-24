import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_learning_app/core/network/api_service.dart';
import 'package:quiz_learning_app/core/network/connectivity_service.dart';
import 'package:quiz_learning_app/core/session/session_cubit.dart';
import 'package:quiz_learning_app/core/session/session_repository.dart';
import 'package:quiz_learning_app/core/storage/local_cache_service.dart';
import 'package:quiz_learning_app/features/auth/bloc/auth_bloc.dart';
import 'package:quiz_learning_app/features/auth/repositories/auth_repository.dart';
import 'package:quiz_learning_app/features/home/bloc/home_bloc.dart';
import 'package:quiz_learning_app/features/profile/bloc/profile_bloc.dart';
import 'package:quiz_learning_app/features/profile/repositories/user_repository.dart';
import 'package:quiz_learning_app/features/quiz/bloc/quiz_bloc.dart';
import 'package:quiz_learning_app/features/quiz/repositories/quiz_repository.dart';
import 'package:quiz_learning_app/features/ranking/bloc/ranking_bloc.dart';
import 'package:quiz_learning_app/features/ranking/repositories/ranking_repository.dart';
import 'package:quiz_learning_app/routes/app_router.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await Hive.initFlutter();

  if (getIt.isRegistered<AppRouter>()) return;

  final cacheService = LocalCacheService();
  await cacheService.init();

  getIt
    ..registerSingleton<LocalCacheService>(cacheService)
    ..registerLazySingleton(ApiService.new)
    ..registerLazySingleton(ConnectivityService.new)
    ..registerLazySingleton(SessionRepository.new)
    ..registerLazySingleton(AuthRepository.new)
    ..registerLazySingleton(UserRepository.new)
    ..registerLazySingleton(RankingRepository.new)
    ..registerLazySingleton(
      () => QuizRepository(
        apiService: getIt(),
        cacheService: getIt(),
        connectivityService: getIt(),
      ),
    )
    ..registerLazySingleton(() => SessionCubit(getIt()))
    ..registerLazySingleton(
      () => AppRouter(sessionCubit: getIt()),
    )
    ..registerFactory(
      () => AuthBloc(
        authRepository: getIt(),
        sessionCubit: getIt(),
      ),
    )
    ..registerFactory(
      () => HomeBloc(
        userRepository: getIt(),
        quizRepository: getIt(),
        connectivityService: getIt(),
        sessionCubit: getIt(),
      ),
    )
    ..registerFactory(
      () => ProfileBloc(
        userRepository: getIt(),
        sessionCubit: getIt(),
      ),
    )
    ..registerFactory(
      () => RankingBloc(
        rankingRepository: getIt(),
        sessionCubit: getIt(),
      ),
    )
    ..registerFactory(
      () => QuizBloc(
        quizRepository: getIt(),
        userRepository: getIt(),
        connectivityService: getIt(),
      ),
    );
}
