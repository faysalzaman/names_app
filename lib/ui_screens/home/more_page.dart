import 'package:flutter/material.dart';
import 'package:names_app/theme/app_theme.dart';
import 'package:names_app/widgets/islamic_pattern.dart';
import 'package:share_plus/share_plus.dart';
import 'package:store_redirect/store_redirect.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  static const _androidAppId = 'com.namesapp.islamic_names_dictionary';

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        PatternedGradient(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(AppSpacing.radiusLg + 8),
          ),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            top + AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'More',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Enjoying Islamic Names? Spread the word.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              _ActionTile(
                icon: Icons.star_rounded,
                title: 'Rate the app',
                subtitle: 'Tell us what you think on the store',
                onTap: () {
                  try {
                    StoreRedirect.redirect(androidAppId: _androidAppId);
                  } catch (e) {
                    debugPrint('Could not open store: $e');
                  }
                },
              ),
              const SizedBox(height: 12),
              _ActionTile(
                icon: Icons.ios_share_rounded,
                title: 'Share with friends',
                subtitle: 'Help others find the perfect name',
                onTap: () => Share.share(
                  'Check out Islamic Names — 20,000+ Muslim boys & girls names '
                  'with meanings.\n'
                  'https://play.google.com/store/apps/details?id=$_androidAppId',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '20,000+ Islamic Names',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.plumMid.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(icon, color: scheme.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
