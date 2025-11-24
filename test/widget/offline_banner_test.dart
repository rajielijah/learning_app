import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_learning_app/common/widgets/offline_banner.dart';
import 'package:quiz_learning_app/l10n/app_localizations.dart';

void main() {
  testWidgets('OfflineBanner shows offline message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: OfflineBanner(),
        ),
      ),
    );

    expect(find.text('You are offline. Showing the last cached quiz.'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
  });
}

