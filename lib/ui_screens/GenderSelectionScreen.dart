// ignore_for_file: avoid_print, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/DataBase/SharedPrefrences.dart';
import 'package:names_app/ui_screens/home_screen.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  NamesBloc? namesBloc;
  NamesSuccess? namesState;
  bool? isViewed;
  AppOpenAd? appOpenAd;

  void getIsViewed() async {
    isViewed = await SharedPreference.getbool(SharedPreference.isViewed);
  }

  @override
  void initState() {
    namesBloc = BlocProvider.of<NamesBloc>(context);
    namesBloc!.add(GetNames());
    getIsViewed();
    super.initState();
    loadAppOpenAd();
  }

  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-9684723099725802/4009423699',
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          showAppOpenAd();
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  void showAppOpenAd() {
    if (appOpenAd != null) {
      appOpenAd!.show();
    }
  }

  @override
  void dispose() {
    appOpenAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/appbackground.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
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
              const SizedBox(height: 20),
              BlocBuilder<NamesBloc, NamesState>(builder: ((context, state) {
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
              })),
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
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => SecondScreen(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }
}
