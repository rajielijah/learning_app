import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_learning_app/common/widgets/offline_banner.dart';
import 'package:quiz_learning_app/core/config/category_config.dart';
import 'package:quiz_learning_app/core/models/quiz_category.dart';
import 'package:quiz_learning_app/core/models/quiz_result.dart';
import 'package:quiz_learning_app/core/models/user_profile.dart';
import 'package:quiz_learning_app/features/home/bloc/home_bloc.dart';
import 'package:quiz_learning_app/l10n/app_localizations.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!state.hasSession && state.loading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final profile = state.profile;
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async =>
                  context.read<HomeBloc>().add(const HomeSyncRequested()),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HeroHeader(
                            profile: profile,
                            l10n: l10n,
                            isSyncing: state.isSyncing,
                          ),
                          const SizedBox(height: 16),
                          if (state.isOffline) ...[
                            const OfflineBanner(),
                            const SizedBox(height: 16),
                          ],
                          Text(
                            l10n.categoriesLabel,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverToBoxAdapter(
                      child: _CategoryGrid(
                        categories: state.categories,
                        progress: state.progress,
                        l10n: l10n,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.profile,
    required this.l10n,
    required this.isSyncing,
  });

  final UserProfile? profile;
  final AppLocalizations l10n;
  final bool isSyncing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(24),
      child: profile == null
          ? const SizedBox(
              height: 120,
              child:
                  Center(child: CircularProgressIndicator(color: Colors.white)),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${l10n.discoverQuizzes}\n${profile!.name}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(profile!.avatarUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile!.email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 12,
                            children: [
                              _StatPill(
                                icon: Icons.military_tech_outlined,
                                label: l10n.profileRank,
                                value: '#${profile!.rank}',
                              ),
                              _StatPill(
                                icon: Icons.stars_rounded,
                                label: l10n.profileScore,
                                value: profile!.score.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isSyncing)
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.categories,
    required this.progress,
    required this.l10n,
  });

  final List<QuizCategory> categories;
  final Map<String, QuizResult> progress;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final columns = MediaQuery.of(context).size.width > 900
        ? 4
        : MediaQuery.of(context).size.width > 600
            ? 3
            : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryProgress = progress[category.id];
        return _CategoryCard(
          category: category,
          result: categoryProgress,
          l10n: l10n,
          onTap: () => context.push('/quiz/${category.id}'),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
    required this.l10n,
    this.result,
  });

  final QuizCategory category;
  final QuizResult? result;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFEEF2FF),
      const Color(0xFFFFF1F3),
      const Color(0xFFE9FBF4),
      const Color(0xFFFFF5E5),
    ];
    final background = colors[category.id.hashCode % colors.length];
    final double progressValue =
        result == null ? 0 : result!.correct / result!.total;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(
                    CategoryConfig.iconFor(category.iconName),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  category.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: progressValue == 0
                      ? null
                      : progressValue.clamp(0, 1).toDouble(),
                  backgroundColor: Colors.white.withOpacity(0.4),
                  color: Theme.of(context).colorScheme.primary,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(12),
                ),
                if (result != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      l10n.lastScore(result!.correct, result!.total),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
