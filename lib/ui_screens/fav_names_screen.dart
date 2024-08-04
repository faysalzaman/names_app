// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:names_app/Bloc/FavouriteBloc/favourite_bloc.dart';
import 'package:names_app/ui_screens/home_screen.dart';
import '../Model/names_model.dart';
import 'detail_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  Icon customIcon = const Icon(Icons.search);
  bool fav = false;

  List<NameModel> listofNames = [];
  String? gender;

  List<NameModel> namemodel = [];
  String? names;

  FavouriteBloc? favouriteBloc;

  InterstitialAd? interstitialAd;

  BannerAd? bannerAd;
  bool isInterstitialAdReady = false;
  bool isBannerAdReady = false;

  @override
  void initState() {
    favouriteBloc = BlocProvider.of<FavouriteBloc>(context);
    favouriteBloc!.add(GetFavourites());
    super.initState();
    loadInterstitialAd();
    loadBannerAd();
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-9684723099725802/6067690957',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          print('InterstitialAd loaded');
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

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-9684723099725802/9851819455',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('BannerAd failed to load: $error');
          ad.dispose();
          isBannerAdReady = false;
        },
      ),
    );
    bannerAd!.load();
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
    } else {
      print('Interstitial ad is not ready yet');
    }
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    bannerAd?.dispose();
    super.dispose();
  }

  // Scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/w.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        drawer: const MyDrawerWidget(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          ],
          title: const Text(
            "Favorite Names",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            BlocBuilder<FavouriteBloc, FavouriteState>(
                builder: (context, state) {
              if (state is FavouriteSuccess) {
                namemodel = state.model;
                if (names != '' && names != null) {
                  listofNames = namemodel
                      .where((element) =>
                          element.englishName!.contains(names.toString()))
                      .toList();

                  // convert list to set to remove duplicates
                  listofNames = listofNames.toSet().toList();

                  print("List of names: $listofNames");

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: listofNames.length,
                    itemBuilder: (BuildContext context, int index) {
                      gender = state.model[index].gender.toString();
                      String genderIcon = "";
                      namemodel[0].gender == "Male" ||
                              namemodel[0].gender == "Boy" ||
                              namemodel[0].gender == "Larka"
                          ? genderIcon = "👨"
                          : genderIcon = "👩";
                      return Column(
                        children: [
                          SizedBox(
                            height: 35,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      model: listofNames[index],
                                    ),
                                  ),
                                );
                                showInterstitialAd();
                              },
                              title: Text(
                                "$genderIcon ${listofNames[index].englishName}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                      itemCount: namemodel.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        String genderIcon = "";
                        namemodel[0].gender == "Male" ||
                                namemodel[0].gender == "Boy" ||
                                namemodel[0].gender == "Larka"
                            ? genderIcon = "👨"
                            : genderIcon = "👩";
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                          model: namemodel[index],
                                        )));
                            showInterstitialAd();
                          },
                          title: Text(
                            "$genderIcon ${namemodel[index].englishName}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        );
                      });
                }
              }
              return Container();
            }),
            if (isBannerAdReady)
              Container(
                color: Colors.transparent,
                width: bannerAd!.size.width.toDouble(),
                height: bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: bannerAd!),
              ),
          ],
        ),
      ),
    );
  }
}
