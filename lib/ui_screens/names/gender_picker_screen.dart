import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/theme/app_theme.dart';
import 'package:names_app/ui_screens/names/name_navigation.dart';
import 'package:names_app/widgets/banner_ad_widget.dart';
import 'package:names_app/widgets/islamic_pattern.dart';

/// Second step of browsing: pick boys or girls within a [category].
class GenderPickerScreen extends StatefulWidget {
  const GenderPickerScreen({super.key, required this.category});

  final NameCategory category;

  @override
  State<GenderPickerScreen> createState() => _GenderPickerScreenState();
}

class _GenderPickerScreenState extends State<GenderPickerScreen> {
  @override
  void initState() {
    super.initState();
    // The splash normally has the data ready; only reload if it isn't.
    final bloc = context.read<NamesBloc>();
    if (bloc.state is! NamesSuccess) bloc.add(GetNames());
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PatternedGradient(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(AppSpacing.radiusLg + 8),
            ),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.sm,
              top + AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg + 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: Colors.white,
                  tooltip: 'Back',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          category.icon,
                          color: AppColors.gold,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        category.title,
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 28,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Who are you naming?',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                _GenderCard(
                  label: 'Boys',
                  caption: 'Strong, noble & timeless',
                  icon: Icons.boy_rounded,
                  colors: const [Color(0xFF1F4E8C), Color(0xFF3B82C4)],
                  onTap: () =>
                      openNameList(context, category: category, boys: true),
                ),
                const SizedBox(height: AppSpacing.md),
                _GenderCard(
                  label: 'Girls',
                  caption: 'Graceful, bright & beloved',
                  icon: Icons.girl_rounded,
                  colors: const [Color(0xFF9C2E6B), Color(0xFFD9609B)],
                  onTap: () =>
                      openNameList(context, category: category, boys: false),
                ),
                BlocBuilder<NamesBloc, NamesState>(
                  builder: (context, state) {
                    if (state is! NamesLoading) return const SizedBox.shrink();
                    return const Padding(
                      padding: EdgeInsets.only(top: AppSpacing.lg),
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.label,
    required this.caption,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final String caption;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 152,
            child: Stack(
              children: [
                Positioned(
                  right: -14,
                  bottom: -22,
                  child: Icon(
                    icon,
                    size: 150,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        caption,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Browse',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
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
