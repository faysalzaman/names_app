import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:names_app/DataBase/Converter.dart';
import 'package:names_app/Model/names_model.dart';
import 'package:names_app/theme/app_theme.dart';
import 'package:names_app/ui_screens/detail_screen.dart';
import 'package:names_app/ui_screens/names/name_navigation.dart';
import 'package:names_app/widgets/islamic_pattern.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _Header()),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          sliver: SliverList.list(
            children: const [
              _QuickBrowse(),
              SizedBox(height: AppSpacing.lg),
              _NameOfTheDay(),
              SizedBox(height: AppSpacing.lg),
              _SectionTitle('Explore collections'),
              SizedBox(height: AppSpacing.sm),
              _CollectionsGrid(),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return PatternedGradient(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(AppSpacing.radiusLg + 8),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        top + AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg + 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  size: 20,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Islamic Names',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Assalamu Alaikum',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 30,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Find a beautiful name with a beautiful meaning.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 15,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            elevation: 6,
            shadowColor: Colors.black.withValues(alpha: 0.3),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              onTap: () => Navigator.of(context)
                  .push(fadeRoute<void>(NameCategory.all.pickerScreen)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.plumMid),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search from 20,000+ names',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.5),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: AppColors.plumMid,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

/// One-tap entry to the full boys / girls lists.
class _QuickBrowse extends StatelessWidget {
  const _QuickBrowse();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderButton(
            label: 'Boys',
            icon: Icons.boy_rounded,
            onTap: () => openNameList(
              context,
              category: NameCategory.all,
              boys: true,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _GenderButton(
            label: 'Girls',
            icon: Icons.girl_rounded,
            onTap: () => openNameList(
              context,
              category: NameCategory.all,
              boys: false,
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.gold, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      'Browse',
                      style: TextStyle(
                        fontSize: 12.5,
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

class _CollectionsGrid extends StatelessWidget {
  const _CollectionsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final category in NameCategory.values) ...[
          _CollectionCard(category: category),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({required this.category});

  final NameCategory category;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            Navigator.of(context).push(fadeRoute<void>(category.pickerScreen)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm + 2),
                ),
                child: Icon(category.icon, color: AppColors.gold, size: 26),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.subtitle,
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

/// A different trending name each day, picked deterministically.
class _NameOfTheDay extends StatefulWidget {
  const _NameOfTheDay();

  @override
  State<_NameOfTheDay> createState() => _NameOfTheDayState();
}

class _NameOfTheDayState extends State<_NameOfTheDay> {
  late final Future<NameModel?> _name = _load();

  Future<NameModel?> _load() async {
    try {
      final now = DateTime.now();
      final dayOfYear = now.difference(DateTime(now.year)).inDays;
      final asset = dayOfYear.isEven ? 'assets/TBoys.json' : 'assets/TGirls.json';
      final json = await rootBundle.loadString(asset);
      final names = (await DataParser(encodedJson: json).parseInBackground())
          .where((n) => (n.englishMeaning ?? '').trim().isNotEmpty)
          .toList();
      if (names.isEmpty) return null;
      return names[(dayOfYear * 7 + now.year) % names.length];
    } catch (e) {
      debugPrint('Name of the day unavailable: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NameModel?>(
      future: _name,
      builder: (context, snapshot) {
        final name = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            height: 132,
            decoration: BoxDecoration(
              color: AppColors.plumMid.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          );
        }
        if (name == null) return const SizedBox.shrink();

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => DetailPage(model: name)),
            ),
            child: PatternedGradient(
              opacity: 0.09,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              padding: const EdgeInsets.all(AppSpacing.md + 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        size: 16,
                        color: AppColors.gold,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'NAME OF THE DAY',
                        style: TextStyle(
                          color: AppColors.gold.withValues(alpha: 0.95),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          name.englishName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      if ((name.urduName ?? '').isNotEmpty &&
                          name.urduName != 'null') ...[
                        const SizedBox(width: 12),
                        Text(
                          name.urduName!,
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name.englishMeaning ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14.5,
                      height: 1.35,
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
