import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_learning_app/common/widgets/app_background.dart';
import 'package:quiz_learning_app/features/auth/bloc/auth_bloc.dart';
import 'package:quiz_learning_app/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'test@gmail.com');
  final _passwordController = TextEditingController(text: 'Test@123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthSubmitted(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBackground(
      child: LayoutBuilder(
      builder: (context, constraints) {
          final isWide = constraints.maxWidth > 920;
        return Scaffold(
            backgroundColor: Colors.transparent,
          body: Center(
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isWide)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 32),
                            child: _HeroPanel(),
                          ),
                        ),
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state.status == AuthStatus.loading;
                                return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                                      Text(
                                        l10n.appTitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(fontWeight: FontWeight.w700),
                                      ),
                        const SizedBox(height: 8),
                                      Text(
                                        l10n.loginSubtitle,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                                        decoration:
                                            InputDecoration(labelText: l10n.emailLabel),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                                            return l10n.emailRequired;
                            }
                            if (!value.contains('@')) {
                                            return l10n.emailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                                        decoration:
                                            InputDecoration(labelText: l10n.passwordLabel),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                                            return l10n.passwordRequired;
                            }
                            if (value.length < 6) {
                                            return l10n.passwordTooShort;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                                      ElevatedButton(
                                        onPressed: isLoading ? null : _onSubmit,
                                        child: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                  )
                                            : Text(l10n.loginCta),
                          ),
                                      if (state.error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                                          l10n.invalidCredentials,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error),
                          ),
                        ],
                      ],
                    ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Level up your quiz game',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Personalized trivia journeys, offline caching, and animated gameplay built for every screen size.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: const [
            _HeroChip(icon: Icons.bolt_rounded, label: 'Animated countdown'),
            _HeroChip(icon: Icons.shield_moon_outlined, label: 'Secure session'),
            _HeroChip(icon: Icons.auto_graph_rounded, label: 'Live rankings'),
          ],
        ),
      ],
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
      label: Text(label),
    );
  }
}
