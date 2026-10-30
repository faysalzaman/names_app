//  ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:names_app/Bloc/FavouriteBloc/favourite_bloc.dart';
import 'package:names_app/Model/name_model_x.dart';
import 'package:names_app/Model/names_model.dart';
import 'package:names_app/theme/app_theme.dart';
import 'package:names_app/widgets/banner_ad_widget.dart';
import 'package:names_app/widgets/islamic_pattern.dart';
import 'package:share_plus/share_plus.dart';

class DetailPage extends StatefulWidget {
  final int? isPageOpen;
  final NameModel? model;

  const DetailPage({
    super.key,
    this.model,
    this.isPageOpen,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _Fact {
  const _Fact(this.label, this.value, this.icon);
  final String label;
  final String? value;
  final IconData icon;
}

class _DetailPageState extends State<DetailPage> {
  bool isFav = false;
  bool isInterstitialAdReady = false;

  InterstitialAd? interstitialAd;
  FavouriteBloc? favouriteBloc;

  NameModel get _model => widget.model!;

  @override
  void initState() {
    favouriteBloc = BlocProvider.of<FavouriteBloc>(context);
    super.initState();

    if (!kIsWeb) loadInterstitialAd();
    isFav = _model.isFav;
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-9684723099725802/6067690957',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
          isInterstitialAdReady = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (isInterstitialAdReady && interstitialAd != null) {
      interstitialAd!.show();
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitialAd();
        },
      );
    }
  }

  void toggleFavorite() {
    setState(() => isFav = !isFav);
    _model.isFavourite = isFav ? '1' : '0';

    favouriteBloc!.add(AddtoFavourite(model: _model));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            isFav ? 'Added to favourites' : 'Removed from favourites',
          ),
          duration: const Duration(seconds: 2),
        ),
      );

    showInterstitialAd();
  }

  void _share() {
    final m = _model;
    Share.share(
      'Name : ${m.englishName} \n Urdu Name : ${m.urduName} \n English Meaning : ${m.englishMeaning} \n Urdu Meaning : ${m.urduMeaning} \n Gender : ${m.gender} \n Religion : ${m.englishReligion} \n Language : ${m.englishLanguage} \n Lucky Color : ${m.englishLuckyColor} \n Lucky Day : ${m.englishLuckyDay} \n Lucky Metals : ${m.englishLuckyMetals} \n Lucky Stones : ${m.englishLuckyStones} \n Famous Person : ${m.englishFamousPerson} \n Description : ${m.englishDescription} \n Known For : ${m.englishKnownFor} \n Occupation/Designation : ${m.englishOccopation}',
    );
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  List<_Fact> _englishFacts() {
    final m = _model;
    return [
      _Fact('Gender', m.isMale ? 'Male' : 'Female',
          m.isMale ? Icons.male_rounded : Icons.female_rounded),
      _Fact('Religion', m.englishReligion, Icons.mosque_outlined),
      _Fact('Language', m.englishLanguage, Icons.translate_rounded),
      _Fact('Lucky Number', m.urduLuckyNumber, Icons.tag_rounded),
      _Fact('Lucky Color', m.englishLuckyColor, Icons.palette_outlined),
      _Fact('Lucky Day', m.englishLuckyDay, Icons.calendar_today_rounded),
      _Fact('Lucky Metal', m.englishLuckyMetals, Icons.hexagon_outlined),
      _Fact('Lucky Stone', m.englishLuckyStones, Icons.diamond_outlined),
    ];
  }

  List<_Fact> _urduFacts() {
    final m = _model;
    return [
      _Fact('جنس', m.isMale ? 'مرد' : 'عورت',
          m.isMale ? Icons.male_rounded : Icons.female_rounded),
      _Fact('مذہب', m.urduReligion, Icons.mosque_outlined),
      _Fact('زبان', m.urduLanguage, Icons.translate_rounded),
      _Fact('خوش قسمت نمبر', m.urduLuckyNumber, Icons.tag_rounded),
      _Fact('خوش قسمت رنگ', m.urduLuckyColor, Icons.palette_outlined),
      _Fact('خوش قسمت دن', m.urduLuckyDay, Icons.calendar_today_rounded),
      _Fact('خوش قسمت دھات', m.urduLuckyMetals, Icons.hexagon_outlined),
      _Fact('خوش قسمت پتھر', m.urduLuckyStones, Icons.diamond_outlined),
    ];
  }

  List<_Fact> _englishSections() {
    final m = _model;
    return [
      _Fact('Description', m.englishDescription, Icons.notes_rounded),
      _Fact('Known For', m.englishKnownFor, Icons.emoji_events_outlined),
      _Fact('Famous Person', m.englishFamousPerson, Icons.person_outline),
      _Fact('Occupation / Designation', m.englishOccopation,
          Icons.work_outline_rounded),
    ];
  }

  List<_Fact> _urduSections() {
    final m = _model;
    return [
      _Fact('تفصیل', m.urduDescription, Icons.notes_rounded),
      _Fact('مشہور برائے', m.urduKnownFor, Icons.emoji_events_outlined),
      _Fact('مشہور شخصیت', m.urduFamousPerson, Icons.person_outline),
      _Fact('پیشہ / عہدہ', m.urduOccopation, Icons.work_outline_rounded),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: const BannerAdWidget(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Hero(
              model: _model,
              isFav: isFav,
              onBack: () => Navigator.of(context).maybePop(),
              onFavourite: toggleFavorite,
              onShare: _share,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _Content(
                    facts: _englishFacts(),
                    sections: _englishSections(),
                    rtl: false,
                  ),
                  _Content(
                    facts: _urduFacts(),
                    sections: _urduSections(),
                    rtl: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.model,
    required this.isFav,
    required this.onBack,
    required this.onFavourite,
    required this.onShare,
  });

  final NameModel model;
  final bool isFav;
  final VoidCallback onBack;
  final VoidCallback onFavourite;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final meaning = model.meaning;
    final urdu = model.urdu;

    return PatternedGradient(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(AppSpacing.radiusLg + 8),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        top + AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.md,
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.white,
                tooltip: 'Back',
              ),
              const Spacer(),
              IconButton(
                onPressed: onShare,
                icon: const Icon(Icons.ios_share_rounded),
                color: Colors.white,
                tooltip: 'Share',
              ),
              IconButton(
                onPressed: onFavourite,
                tooltip: isFav ? 'Remove from favourites' : 'Add to favourites',
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey(isFav),
                    color: isFav ? const Color(0xFFFF6B8B) : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        model.isMale ? Icons.male_rounded : Icons.female_rounded,
                        size: 16,
                        color: AppColors.gold,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        model.isMale ? 'Boy name' : 'Girl name',
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  model.displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                if (urdu != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    urdu,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 28,
                    ),
                  ),
                ],
                if (meaning != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    meaning,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 15.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(26),
                ),
                labelColor: AppColors.plumDeep,
                unselectedLabelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                splashBorderRadius: BorderRadius.circular(26),
                tabs: const [
                  Tab(height: 40, text: 'English'),
                  Tab(height: 40, text: 'اردو'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.facts,
    required this.sections,
    required this.rtl,
  });

  final List<_Fact> facts;
  final List<_Fact> sections;
  final bool rtl;

  static bool _has(_Fact f) => NameModelX.clean(f.value) != null;

  @override
  Widget build(BuildContext context) {
    final shownFacts = facts.where(_has).toList();
    final shownSections = sections.where(_has).toList();

    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (shownFacts.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {
                const gap = 10.0;
                final width = (constraints.maxWidth - gap) / 2;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final f in shownFacts)
                      SizedBox(width: width, child: _FactCard(fact: f)),
                  ],
                );
              },
            ),
          for (final s in shownSections) ...[
            const SizedBox(height: 12),
            _SectionCard(section: s),
          ],
          if (shownFacts.isEmpty && shownSections.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.xl),
              child: Center(child: Text('No further details available.')),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _FactCard extends StatelessWidget {
  const _FactCard({required this.fact});

  final _Fact fact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(fact.icon, size: 18, color: scheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    fact.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              NameModelX.clean(fact.value) ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final _Fact section;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(section.icon, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  section.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              NameModelX.clean(section.value) ?? '',
              style: const TextStyle(fontSize: 15.5, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
