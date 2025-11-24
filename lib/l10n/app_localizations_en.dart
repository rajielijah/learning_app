// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Quiz Learning';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password is too short';

  @override
  String get loginCta => 'Login';

  @override
  String get invalidCredentials => 'Invalid email, please try again';

  @override
  String get discoverQuizzes => 'Discover Quizzes';

  @override
  String get categoriesLabel => 'Categories';

  @override
  String get offlineBannerMessage =>
      'You are offline. Showing the last cached quiz.';

  @override
  String get profileRank => 'Rank';

  @override
  String get profileScore => 'Score';

  @override
  String lastScore(int correct, int total) {
    return 'Last score: $correct/$total';
  }

  @override
  String quizResultTitle(Object category) {
    return 'Completed: $category';
  }

  @override
  String quizResultSummary(int correct, int total, int percent) {
    return 'Score: $correct/$total • $percent%';
  }

  @override
  String get backToHome => 'Back to Home';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get scoreLabel => 'Score';

  @override
  String get correctLabel => 'Correct';

  @override
  String get incorrectLabel => 'Incorrect';

  @override
  String get quizError => 'Unable to start quiz';

  @override
  String get topLearners => 'Top Learners';
}
