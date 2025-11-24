import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_learning_app/common/widgets/app_background.dart';
import 'package:quiz_learning_app/common/widgets/offline_banner.dart';
import 'package:quiz_learning_app/core/config/category_config.dart';
import 'package:quiz_learning_app/core/models/quiz_question.dart';
import 'package:quiz_learning_app/core/models/quiz_result.dart';
import 'package:quiz_learning_app/features/home/bloc/home_bloc.dart';
import 'package:quiz_learning_app/features/quiz/bloc/quiz_bloc.dart';
import 'package:quiz_learning_app/l10n/app_localizations.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.categoryId});

  final String categoryId;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool _navigatedHome = false;
  late final String _categoryName = CategoryConfig.categories
      .firstWhere(
        (element) => element.id == widget.categoryId,
        orElse: () => CategoryConfig.categories.first,
      )
      .name;
  late final QuizBloc _quizBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _quizBloc = context.read<QuizBloc>();
  }

  @override
  void dispose() {
    _quizBloc.add(const QuizCleared());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<QuizBloc, QuizState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == QuizStatus.completed && !_navigatedHome) {
          final result = state.latestResult;
          if (result != null) {
            context.read<HomeBloc>().add(HomeProgressUpdated(result));
          }
          _navigatedHome = true;
          Future<void>.delayed(const Duration(seconds: 2), () {
            if (mounted) context.go('/home');
          });
        }
      },
      child: AppBackground(
        showOverlay: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: Text('${l10n.quizTitle}: $_categoryName')),
          body: SafeArea(
            child: BlocBuilder<QuizBloc, QuizState>(
              builder: (context, state) {
                switch (state.status) {
                  case QuizStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case QuizStatus.failure:
                    return _ErrorView(
                      message: state.error ?? l10n.quizError,
                      retryLabel: l10n.loginCta,
                      onRetry: () => context.read<QuizBloc>().add(
                            QuizRequested(widget.categoryId),
                          ),
                    );
                  case QuizStatus.completed:
                    return _ResultView(
                      result: state.latestResult,
                      categoryName: _categoryName,
                      l10n: l10n,
                    );
                  default:
                    return Stack(
                      children: [
                        _QuizBody(state: state, l10n: l10n),
                        if (state.status == QuizStatus.countdown)
                          _CountdownOverlay(value: state.countdownValue),
                      ],
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizBody extends StatelessWidget {
  const _QuizBody({required this.state, required this.l10n});

  final QuizState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (state.questions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final question = state.questions[state.currentIndex];
    final progress = (state.currentIndex + 1) / state.questions.length;
    final colorScheme = Theme.of(context).colorScheme;
    final isEvaluating = state.status == QuizStatus.evaluating;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            color: colorScheme.secondary,
            backgroundColor: Colors.white.withOpacity(0.3),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${state.currentIndex + 1}/${state.questions.length}',
                style: Theme.of(context).textTheme.bodyMedium),
            Row(
              children: [
                _TimerBadge(remaining: state.remainingSeconds),
                const SizedBox(width: 12),
                Text('${l10n.scoreLabel}: ${state.correctCount}',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (state.isOffline) ...[
          const OfflineBanner(),
          const SizedBox(height: 16),
        ],
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.category,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 12),
                Semantics(
                  label: 'Question text',
                  child: Text(
                    question.question,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...question.choices.map(
          (answer) => _AnswerTile(
            answer: answer,
            question: question,
            isEvaluating: isEvaluating,
            selectedAnswer: state.selectedAnswer,
            onTap: () =>
                context.read<QuizBloc>().add(QuizAnswerSelected(answer)),
          ),
        ),
        if (isEvaluating)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              state.lastAnswerCorrect == true
                  ? l10n.correctLabel
                  : l10n.incorrectLabel,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: state.lastAnswerCorrect == true
                        ? colorScheme.primary
                        : colorScheme.error,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile({
    required this.answer,
    required this.question,
    required this.isEvaluating,
    required this.selectedAnswer,
    required this.onTap,
  });

  final String answer;
  final QuizQuestion question;
  final bool isEvaluating;
  final String? selectedAnswer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCorrect = answer == question.correctAnswer;
    final selected = selectedAnswer == answer;
    final baseBorder = Theme.of(context).colorScheme.outlineVariant;
    Color borderColor = baseBorder;
    Color? fillColor;
    IconData? icon;

    if (isEvaluating) {
      if (isCorrect) {
        borderColor = Colors.green;
        fillColor = Colors.green.withOpacity(0.1);
        icon = Icons.check_circle;
      } else if (selected) {
        borderColor = Colors.red;
        fillColor = Colors.red.withOpacity(0.1);
        icon = Icons.cancel_outlined;
      }
    } else if (selected) {
      borderColor = Theme.of(context).colorScheme.primary;
      fillColor = Theme.of(context).colorScheme.primary.withOpacity(0.08);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Semantics(
        button: true,
        label: 'Answer option $answer',
        child: InkWell(
          onTap: isEvaluating ? null : onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: borderColor, width: 1.5),
              color: fillColor ?? Colors.white,
            ),
            child: Row(
              children: [
                Expanded(child: Text(answer)),
                if (icon != null)
                  Icon(
                    icon,
                    color: borderColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TimerBadge extends StatelessWidget {
  const _TimerBadge({required this.remaining});

  final int remaining;

  @override
  Widget build(BuildContext context) {
    final progress = remaining / 60;
    return SizedBox(
      width: 54,
      height: 54,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress.clamp(0, 1).toDouble(),
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.white.withOpacity(0.3),
          ),
          Center(
            child: Text(
              '$remaining',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownOverlay extends StatelessWidget {
  const _CountdownOverlay({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              '$value',
              key: ValueKey<int>(value),
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.white, fontSize: 96),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.result,
    required this.categoryName,
    required this.l10n,
  });

  final QuizResult? result;
  final String categoryName;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Center(child: Text(l10n.quizError));
    }
    final accuracy = (result!.correct / result!.total * 100).round();
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.quizResultTitle(categoryName),
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                l10n.quizResultSummary(
                  result!.correct,
                  result!.total,
                  accuracy,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: Text(l10n.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(retryLabel)),
        ],
      ),
    );
  }
}
