// ignore_for_file: must_be_immutable, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:names_app/Bloc/FavouriteBloc/favourite_bloc.dart';
import '../Model/names_model.dart';
import 'package:share_plus/share_plus.dart';

class DetailPage extends StatefulWidget {
  int? isPageOpen;
  NameModel? model;
  DetailPage({super.key, this.model, this.isPageOpen});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFav = false;
  InterstitialAd? interstitialAd;
  BannerAd? bannerAd;
  bool isInterstitialAdReady = false;
  bool isBannerAdReady = false;

  final horizantalSpacing = const SizedBox(height: 12);
  final kboldTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.white,
  );
  final ktextStyle = const TextStyle(
    fontSize: 18,
    color: Colors.white,
  );
  FavouriteBloc? favouriteBloc;

  @override
  void initState() {
    favouriteBloc = BlocProvider.of<FavouriteBloc>(context);
    super.initState();
    loadInterstitialAd();
    loadBannerAd();
    isFav = widget.model!.isFavourite == "true";
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

  void toggleFavorite() {
    setState(() {
      isFav = !isFav;
    });

    if (isFav) {
      widget.model!.isFavourite = "true";
    } else {
      widget.model!.isFavourite = "false";
    }

    favouriteBloc!.add(AddtoFavourite(model: widget.model!));

    showInterstitialAd();
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/appbackground.jpg"), fit: BoxFit.fill),
        ),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Share.share(
                  'Name : ${widget.model!.englishName} \n Urdu Name : ${widget.model!.urduName} \n English Meaning : ${widget.model!.englishMeaning} \n Urdu Meaning : ${widget.model!.urduMeaning} \n Gender : ${widget.model!.gender}"');
            },
            child: const Icon(Icons.share),
          ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.keyboard_backspace_outlined)),
            automaticallyImplyLeading: false,
            title: const Text('Islamic Names'),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text('English')),
                Tab(
                  child: Text('اردو'),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: toggleFavorite,
                icon: Icon(
                  isFav
                      ? Icons.favorite_outlined
                      : Icons.favorite_outline_sharp,
                  color: isFav ? Colors.red : Colors.black,
                ),
              ),
            ],
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Name
                            Row(
                              children: [
                                Text(
                                  'Name :',
                                  style: kboldTextStyle,
                                ),
                                Text(
                                  '${widget.model!.englishName}',
                                  style: ktextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Text(
                              'Meaning : ${widget.model!.englishMeaning}',
                              style: ktextStyle,
                            ),
                            horizantalSpacing,
                            Row(
                              children: [
                                Text(
                                  'Gender :',
                                  style: kboldTextStyle,
                                ),
                                Text(
                                  '${widget.model!.gender}',
                                  style: ktextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              children: [
                                Text(
                                  'Religion :',
                                  style: kboldTextStyle,
                                ),
                                Text(
                                  '${widget.model!.englishReligion}',
                                  style: ktextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              children: [
                                Text(
                                  'Language :',
                                  style: kboldTextStyle,
                                ),
                                Text(
                                  '${widget.model!.englishLanguage}',
                                  style: ktextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              children: [
                                Text(
                                  'Lucky Number :',
                                  style: kboldTextStyle,
                                ),
                                Text(
                                  '${widget.model!.englishLuckyNumber}',
                                  style: ktextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              children: [
                                Text(
                                  'Lucky Color :',
                                  style: kboldTextStyle,
                                ),
                                Text(
                                  '${widget.model!.englishLuckyColor}',
                                  style: ktextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              children: [
                                Text(
                                  'Lucky Day :',
                                  style: kboldTextStyle,
                                ),
                                Text(
                                  '${widget.model!.englishLuckyDay}',
                                  style: ktextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              children: [
                                Text(
                                  'Lucky Metals :',
                                  style: kboldTextStyle,
                                ),
                                Text(
                                  '${widget.model!.englishLuckyMetals}',
                                  style: ktextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              children: [
                                Text(
                                  'Lucky Stones :',
                                  style: kboldTextStyle,
                                ),
                                Text(
                                  '${widget.model!.englishLuckyStones}',
                                  style: ktextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.model!.urduName} : ',
                                  style: ktextStyle,
                                ),
                                Text(
                                  'نام',
                                  style: kboldTextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.model!.urduMeaning} : ',
                                  style: ktextStyle,
                                ),
                                Text(
                                  'مطلب',
                                  style: kboldTextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.model!.gender == "Male" ? "مرد" : "عورت"} : ',
                                  style: ktextStyle,
                                ),
                                Text(
                                  'جنس:',
                                  style: kboldTextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.model!.urduReligion} : ',
                                  style: ktextStyle,
                                ),
                                Text(
                                  'مذہب',
                                  style: kboldTextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.model!.urduLanguage} : ',
                                  style: ktextStyle,
                                ),
                                Text(
                                  ' زبان',
                                  style: kboldTextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.model!.urduLuckyColor} : ',
                                  style: ktextStyle,
                                ),
                                Text(
                                  'خوش قسمت رنگ',
                                  style: kboldTextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.model!.urduLuckyDay} : ',
                                  style: ktextStyle,
                                ),
                                Text(
                                  ' خوش قسمت دن',
                                  style: kboldTextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.model!.urduLuckyMetals} : ',
                                  style: ktextStyle,
                                ),
                                Text(
                                  'خوش قسمت دھات',
                                  style: kboldTextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.model!.urduLuckyNumber} : ',
                                  style: ktextStyle,
                                ),
                                Text(
                                  'خوش قسمت نمبر',
                                  style: kboldTextStyle,
                                ),
                              ],
                            ),
                            horizantalSpacing,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${widget.model!.urduLuckyStones} : ',
                                  style: ktextStyle,
                                ),
                                Text(
                                  'خوش قسمت پتھر',
                                  style: kboldTextStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
