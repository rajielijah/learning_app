# Quiz Learning App

Cross-platform Flutter quiz learning experience for Web, Android, and iOS with offline-first quiz playback and local ranking support.

## Architecture

- **Feature-first structure**: `features/{auth,home,quiz,profile,ranking}` hold UI, bloc, repositories for each domain.
- **Core layer**: shared models, services, storage, networking, routing, theming, and dependency injection (`core/di/service_locator.dart`).
- **State management**: `flutter_bloc` across the app (`AuthBloc`, `HomeBloc`, `QuizBloc`, `ProfileBloc`, `RankingBloc`, `SessionCubit`).
- **Routing**: `GoRouter` with `/login`, `/home` (tab shell: Profile, Home, Ranking), `/quiz/:categoryId`.
- **Dependency Injection**: `get_it` registers repositories, services, blocs, and router.
- **Offline-first**: `LocalCacheService` caches quiz questions & results in Hive. `ConnectivityService` toggles offline banner, loads cached quizzes, and syncs pending results when connectivity returns.
- **API**: Open Trivia DB via `ApiService` (Dio). Ranking data sourced from `assets/mock/ranking.json` (Mockaroo style).
- **UI**: Responsive layouts, semantic labels, countdown animations, progress indicators, and light theming (Material 3). Tab bar hides automatically when navigating to `/quiz/:categoryId`.

## Getting Started

```bash
flutter pub get
flutter run -d chrome   # or ios/android/web device of choice
```

### Useful Commands

- `flutter test` – runs unit + widget tests in `test/unit` and `test/widget`.
- `flutter run -d chrome --web-renderer canvaskit` – recommended for smoother countdown animations on web.

## Testing

- `test/unit/quiz_question_test.dart`: verifies Open Trivia payload parsing + HTML decoding.
- `test/widget/offline_banner_test.dart`: ensures offline banner renders accessible copy.


## Localization

- Strings live in `l10n/intl_en.arb`. Run `flutter gen-l10n` after editing ARB files.
- Access localized text through `AppLocalizations` (already wired in `main.dart`).

## CI/CD

- `.github/workflows/ci.yml` runs on push/PR: `flutter test`, builds Android APK + iOS IPA, uploads artifacts.


## Future Improvements

- Set up the GitHub Actions SMTP/email step once credentials are available, or integrate with an alternative artifact distribution mechanism.
- Swap the handwritten ranking dataset for a Mockaroo-generated one with richer fields
  (country, bio, activity level), giving a more realistic leaderboard simulation.

## Notes

- Valid login: `test@gmail.com / Test@123`.
- Categories are mapped 1:1 with Open Trivia DB IDs in `core/config/category_config.dart`.

- Localization ready with `flutter_localizations` (`en` default).
