// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:names_app/Bloc/FavouriteBloc/favourite_bloc.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/DataBase/SharedPrefrences.dart';
import 'package:names_app/ui_screens/GenderSelectionScreen.dart';

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
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key}) : super(key: key);

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  _MyHomePageState createState() => _MyHomePageState();
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
    namesBloc = BlocProvider.of<NamesBloc>(context);
    namesBloc!.add(GetNames());

    appOpenedCount();
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GenderSelectionScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              // height: 300,
              child: Image.asset(
                'assets/OnBoardingScreen.jpeg',
                fit: BoxFit.fill,
                // height: 300,
              )),
          Container(
            margin: const EdgeInsets.only(bottom: 100),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
