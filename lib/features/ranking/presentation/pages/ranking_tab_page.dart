import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_learning_app/core/models/ranking_user.dart';
import 'package:quiz_learning_app/features/ranking/bloc/ranking_bloc.dart';
import 'package:quiz_learning_app/l10n/app_localizations.dart';

class RankingTabPage extends StatelessWidget {
  const RankingTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: BlocBuilder<RankingBloc, RankingState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          final users = state.users;
          final topThree = users.take(3).toList();
          final remaining = users.skip(3).toList();
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(l10n.topLearners),
                floating: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.spaceBetween,
                    children: topThree
                        .map(
                          (user) => _PodiumCard(
                            user: user,
                            highlight: state.highlightUserId == user.id,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.separated(
                  itemCount: remaining.length,
                  itemBuilder: (context, index) {
                    final user = remaining[index];
                    final isCurrent = state.highlightUserId == user.id;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCurrent
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                        title: Text(user.name),
                        subtitle: Text('Score: ${user.score}'),
                        trailing: Text('#${user.rank}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        },
      ),
    );
  }
}

class _PodiumCard extends StatelessWidget {
  const _PodiumCard({required this.user, required this.highlight});

  final RankingUser user;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final width = size > 600 ? (size / 3) - 32 : double.infinity;
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFEAB5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: highlight ? Colors.white : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text('Score: ${user.score}',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Chip(
            label: Text('#${user.rank}'),
            avatar: const Icon(Icons.emoji_events, size: 18),
          ),
        ],
      ),
    );
  }
}
