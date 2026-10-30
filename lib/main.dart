//  ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:names_app/Bloc/FavouriteBloc/favourite_bloc.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/DataBase/SharedPrefrences.dart';
import 'package:names_app/theme/app_theme.dart';
import 'package:names_app/ui_screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) MobileAds.instance.initialize();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NamesBloc>(create: (context) => NamesBloc()),
        BlocProvider<FavouriteBloc>(create: (context) => FavouriteBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
    SharedPreference.savebool(SharedPreference.isViewedPopUP, false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Islamic Names',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
