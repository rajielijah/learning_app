import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quiz_learning_app/l10n/app_localizations.dart';
import 'package:quiz_learning_app/core/di/service_locator.dart';
import 'package:quiz_learning_app/core/session/session_cubit.dart';
import 'package:quiz_learning_app/features/home/bloc/home_bloc.dart';
import 'package:quiz_learning_app/routes/app_router.dart';
import 'package:quiz_learning_app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const QuizLearningApp());
}

class QuizLearningApp extends StatefulWidget {
  const QuizLearningApp({super.key});

  @override
  State<QuizLearningApp> createState() => _QuizLearningAppState();
}

class _QuizLearningAppState extends State<QuizLearningApp> {
  late final SessionCubit _sessionCubit = getIt<SessionCubit>();
  late final AppRouter _appRouter = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _sessionCubit),
        BlocProvider<HomeBloc>(
          create: (_) => getIt<HomeBloc>()..add(const HomeStarted()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Quiz Learning',
        theme: AppTheme.light(),
        routerConfig: _appRouter.router,
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
