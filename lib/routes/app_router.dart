import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_learning_app/core/di/service_locator.dart';
import 'package:quiz_learning_app/core/session/session_cubit.dart';
import 'package:quiz_learning_app/features/auth/bloc/auth_bloc.dart';
import 'package:quiz_learning_app/features/auth/presentation/screens/login_screen.dart';
import 'package:quiz_learning_app/features/home/presentation/pages/home_shell_page.dart';
import 'package:quiz_learning_app/features/home/presentation/pages/home_tab_page.dart';
import 'package:quiz_learning_app/features/profile/bloc/profile_bloc.dart';
import 'package:quiz_learning_app/features/profile/presentation/pages/profile_tab_page.dart';
import 'package:quiz_learning_app/features/quiz/bloc/quiz_bloc.dart';
import 'package:quiz_learning_app/features/quiz/presentation/pages/quiz_page.dart';
import 'package:quiz_learning_app/features/ranking/bloc/ranking_bloc.dart';
import 'package:quiz_learning_app/features/ranking/presentation/pages/ranking_tab_page.dart';
import 'package:quiz_learning_app/routes/router_refresh.dart';

class AppRouter {
  AppRouter({required SessionCubit sessionCubit}) : _sessionCubit = sessionCubit;

  final SessionCubit _sessionCubit;
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(_sessionCubit.stream),
    redirect: (context, state) {
      final isLoggedIn = _sessionCubit.state.isAuthenticated;
      final loggingIn = state.uri.path == '/login';
      if (!isLoggedIn && !loggingIn) return '/login';
      if (isLoggedIn && loggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<AuthBloc>(),
          child: const LoginScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShellPage(shell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<ProfileBloc>()..add(const ProfileStarted()),
                child: const ProfileTabPage(),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeTabPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/ranking',
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<RankingBloc>()..add(const RankingStarted()),
                child: const RankingTabPage(),
              ),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/quiz/:categoryId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return BlocProvider(
            create: (_) => getIt<QuizBloc>()..add(QuizRequested(categoryId)),
            child: QuizPage(categoryId: categoryId),
          );
        },
      ),
    ],
  );
}
