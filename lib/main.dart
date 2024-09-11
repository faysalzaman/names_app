//  ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:names_app/Bloc/FavouriteBloc/favourite_bloc.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/DataBase/SharedPrefrences.dart';
import 'package:names_app/ui_screens/names/GenderSelectionScreen.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
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
  //  ignore: use_key_in_widget_constructors
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SharedPreference.savebool(SharedPreference.isViewedPopUP, false);
  }

  //  This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Names App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.purple,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.purple,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static int? appopenedCounts;

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NamesBloc? namesBloc;

  void appOpenedCount() async {
    int appcountsInc;
    String appopenedCount =
        await SharedPreference.getString(SharedPreference.appOpenedCount);
    MyHomePage.appopenedCounts =
        appopenedCount.isEmpty ? 0 : int.parse(appopenedCount);
    appcountsInc =
        appopenedCount.isEmpty ? 1 : (MyHomePage.appopenedCounts)! + 1;

    SharedPreference.saveString(
        SharedPreference.appOpenedCount, appcountsInc.toString());
  }

  @override
  void initState() {
    super.initState();

    namesBloc = BlocProvider.of<NamesBloc>(context);
    namesBloc!.add(GetNames());

    appOpenedCount();

    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const GenderSelectionScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              // height: 300,
              child: Image.asset(
                'assets/OnBoardingScreen.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 100),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.purple),
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                      ),
                    ],
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
