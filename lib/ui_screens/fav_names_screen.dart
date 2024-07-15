import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:names_app/Bloc/FavouriteBloc/favourite_bloc.dart';
import '../Model/names_model.dart';
import '../main.dart';
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
  Widget customSearchBar = const Text(
    'Islamic Names',
    style: TextStyle(letterSpacing: 2),
  );
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
      request: AdRequest(),
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
      request: AdRequest(),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/appbackground.jpg"), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: Drawer(
          backgroundColor: Colors.purple,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                width: 200,
                height: 180,
                child: SvgPicture.asset(
                  "assets/aboveMenuImage.svg",
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                title: const Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              ),
              ListTile(
                title: const Text(
                  'Favourites',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FavouritesScreen()));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: customSearchBar,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        onChanged: (name) {
                          setState(() {
                            names = name.isEmpty ? '' : name;
                            listofNames = namemodel
                                .where((element) =>
                                    element.englishName!.contains(names!))
                                .toList();
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'type in your name...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text(
                      'Islamic Names',
                      style: TextStyle(letterSpacing: 2),
                    );
                  }
                });
              },
              icon: customIcon,
            ),
          ],
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<FavouriteBloc, FavouriteState>(
                  builder: (context, state) {
                if (state is FavouriteSuccess) {
                  namemodel = state.model!;
                  namemodel = namemodel.toSet().toList(); // Remove duplicates
                  if (names != '' && names != null) {
                    listofNames = namemodel
                        .where(
                            (element) => element.englishName!.contains(names!))
                        .toList();
                    return ListView.builder(
                      itemCount: listofNames.length,
                      itemBuilder: (BuildContext context, int index) {
                        gender = state.model![index].gender;
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
                                  "${listofNames[index].englishName}",
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
                        itemBuilder: (BuildContext context, int index) {
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
                              "${namemodel[index].englishName}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          );
                        });
                  }
                }
                return Container();
              }),
            ),
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
