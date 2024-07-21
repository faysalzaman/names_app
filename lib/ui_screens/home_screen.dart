// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unnecessary_null_comparison, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/Model/names_model.dart';
import 'package:names_app/ui_screens/GenderSelectionScreen.dart';
import 'package:names_app/ui_screens/fav_names_screen.dart';
import 'package:store_redirect/store_redirect.dart';
import '../DataBase/SharedPrefrences.dart';
import '../main.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  int? isHomeScreenOpen = 0;
  HomeScreen({super.key, this.isHomeScreenOpen});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  Icon customIcon = const Icon(Icons.search);
  bool fav = false;
  Widget customSearchBar = const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        'Islamic Names',
        style: TextStyle(),
      ),
      SizedBox(
        height: 5,
      ),
      Text(
        'Browse',
        style: TextStyle(fontSize: 12),
      ),
    ],
  );

  List<NameModel> listofNames = [];
  List<NameModel> namemodel = [];
  String? names;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  String? gender;

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

  void _showDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildPopupDialog(context),
    );
  }

  void showDialogue() async {
    if ([2, 10, 20, 30].contains(MyHomePage.appopenedCounts)) {
      String? date =
          await SharedPreference.getString(SharedPreference.isViewedPopUP);
      if (date == null ||
          date != DateFormat("yyyy-MM-dd").format(DateTime.now())) {
        Future.delayed(Duration.zero, () => _showDialogue(context));
        SharedPreference.saveString(SharedPreference.isViewedPopUP,
            DateFormat("yyyy-MM-dd").format(DateTime.now()));
      }
    }
  }

  // scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    showDialogue();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      drawer: Drawer(
        backgroundColor: Colors.purple,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
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
                  MaterialPageRoute(
                    builder: (context) => const GenderSelectionScreen(),
                  ),
                );
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
            ExpansionTile(
              iconColor: Colors.white,
              title: const Text(
                'Gender',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              children: [
                ListTile(
                    onTap: () {
                      BlocProvider.of<NamesBloc>(context)
                          .add(GetNamesOnGender(gender: "Male"));
                      Navigator.pop(context);
                    },
                    title: const Text('Male',
                        style: TextStyle(color: Colors.white, fontSize: 20))),
                ListTile(
                  onTap: () {
                    BlocProvider.of<NamesBloc>(context)
                        .add(GetNamesOnGender(gender: "Female"));
                    Navigator.pop(context);
                  },
                  title: const Text('Female',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: customSearchBar,
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
              setState(
                () {
                  if (customIcon.icon == Icons.search) {
                    customIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      title: TextField(
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (name) {
                          setState(() {
                            names = name.isEmpty ? '' : name;
                            listofNames = namemodel
                                .where((element) =>
                                    element.englishName!.contains(names!))
                                .toList();

                            // and when the name is empty, then it will show all the names
                            if (name.isEmpty) {
                              listofNames = namemodel;
                            }
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Type Name',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    );
                  } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Islamic Names',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Browse',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  }
                },
              );
            },
            icon: customIcon,
          ),
          // drawer icon button
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ],
        centerTitle: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/appbackground.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocBuilder<NamesBloc, NamesState>(builder: (context, state) {
          if (state is NamesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NamesSuccess) {
            namemodel = state.filteredList!;
            if (names != '' && names != null) {
              return ListView.builder(
                itemCount: listofNames.length,
                itemBuilder: (BuildContext context, int index) {
                  gender = state.filteredList![index].gender;
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
                                  isPageOpen: widget.isHomeScreenOpen,
                                  model: listofNames[index],
                                ),
                              ),
                            );
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
                itemCount: state.filteredList!.length,
                itemBuilder: (BuildContext context, int index) {
                  gender = state.filteredList![index].gender;
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
                                  isPageOpen: widget.isHomeScreenOpen,
                                  model: state.filteredList![index],
                                ),
                              ),
                            );
                          },
                          title: Text(
                            "${state.filteredList![index].englishName}",
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
            }
          }
          return const SizedBox(
            child: Text('No Data Found'),
          );
        }),
      ),
      bottomNavigationBar: _isAdLoaded
          ? SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : const SizedBox(),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Rate Us'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: Text("Rate this App")),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.purple,
              ),
              Icon(
                Icons.star,
                color: Colors.purple,
              ),
              Icon(
                Icons.star,
                color: Colors.purple,
              ),
              Icon(
                Icons.star_border,
                color: Colors.purple,
              ),
              Icon(
                Icons.star_border,
                color: Colors.purple,
              ),
            ],
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            StoreRedirect.redirect(
              androidAppId: "com.namesapp.islamic_names_dictionary",
            );
          },
          child: const Text('Open'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
