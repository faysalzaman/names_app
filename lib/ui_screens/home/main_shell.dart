// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:names_app/Bloc/FavouriteBloc/favourite_bloc.dart';
import 'package:names_app/ui_screens/fav_names_screen.dart';
import 'package:names_app/ui_screens/home/home_page.dart';
import 'package:names_app/ui_screens/home/more_page.dart';
import 'package:names_app/widgets/banner_ad_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App frame: bottom navigation between Home, Favourites and More.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _favouritesTab = 1;

  final InAppReview _inAppReview = InAppReview.instance;
  AppOpenAd? _appOpenAd;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _checkAndShowRatingDialog();
  }

  @override
  void dispose() {
    _appOpenAd?.dispose();
    super.dispose();
  }

  void _select(int i) {
    if (i == _favouritesTab) {
      context.read<FavouriteBloc>().add(GetFavourites());
    }
    setState(() => _index = i);
  }

  Future<void> _showRatingDialog() async {
    final isAvailable = await _inAppReview.isAvailable();
    if (isAvailable) {
      _inAppReview.requestReview().catchError((e) {
        print('Failed to request in-app review: $e');
      });
    } else {
      _inAppReview
          .openStoreListing(appStoreId: '8475602794689359855')
          .catchError((e) {
        print('Failed to open store listing: $e');
      });
    }
  }

  Future<void> _checkAndShowRatingDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final appLaunchCount = (prefs.getInt('appLaunchCount') ?? 0) + 1;

    if (appLaunchCount >= 3) {
      _showRatingDialog();
      prefs.setInt('appLaunchCount', 0);
    } else {
      prefs.setInt('appLaunchCount', appLaunchCount);
      _loadAppOpenAd();
    }
  }

  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-9684723099725802/4009423699',
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          ad.show();
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          HomePage(),
          FavouritesScreen(),
          MorePage(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BannerAdWidget(),
          NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _select,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border_rounded),
                selectedIcon: Icon(Icons.favorite_rounded),
                label: 'Favourites',
              ),
              NavigationDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view_rounded),
                label: 'More',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
