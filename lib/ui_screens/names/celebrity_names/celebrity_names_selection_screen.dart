// ignore_for_file: avoid_print, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/DataBase/SharedPrefrences.dart';
import 'package:names_app/ui_screens/home_screen.dart';

class CelebrityNamesSelectionScreen extends StatefulWidget {
  const CelebrityNamesSelectionScreen({super.key});

  @override
  _CelebrityNamesSelectionScreenState createState() =>
      _CelebrityNamesSelectionScreenState();
}

class _CelebrityNamesSelectionScreenState
    extends State<CelebrityNamesSelectionScreen> {
  NamesBloc? namesBloc;
  NamesSuccess? namesState;
  bool? isViewed;

  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  void getIsViewed() async {
    isViewed = await SharedPreference.getbool(SharedPreference.isViewed);
  }

  @override
  void initState() {
    super.initState();
    _initBannerAd();
    namesBloc = BlocProvider.of<NamesBloc>(context);
    namesBloc!.add(GetNames());
    getIsViewed();
  }

  void _initBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId:
          'ca-app-pub-9684723099725802/9851819455', // Use your real ad unit ID
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(
              'Failed to load a banner ad: $error'); // Optional: Add logging for errors
        },
      ),
      request: const AdRequest(),
    );
    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: _isAdLoaded
          ? SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : const SizedBox(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/appbackground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () => submit('Male'),
                color: Colors.purple,
                shape: const StadiumBorder(),
                // ignore: prefer_const_constructors
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: const SizedBox(
                    width: 170,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Male',
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/boy.jpeg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              MaterialButton(
                onPressed: () => submit('Female'),
                color: Colors.purple,
                shape: const StadiumBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: 170,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Female',
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/girl.jpeg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              BlocBuilder<NamesBloc, NamesState>(
                builder: ((context, state) {
                  if (state is NamesLoading) {
                    return Column(
                      children: [
                        isViewed == false
                            ? const Text(
                                'Extracting Data...',
                                style: TextStyle(color: Colors.white),
                              )
                            : Container(),
                        const SizedBox(height: 10),
                        isViewed == false
                            ? const CircularProgressIndicator()
                            : Container(),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit(String gender) {
    var namestate = BlocProvider.of<NamesBloc>(context).state;
    if (namestate is NamesSuccess) {
      namesState = namestate;
    }
    namesBloc!.add(GetNamesOnGender(gender: gender, list: namesState!.model));
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => HomeScreen(),
      ),
    );
  }
}
