// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unnecessary_null_comparison, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/Model/names_model.dart';
import 'package:names_app/ui_screens/names/GenderSelectionScreen.dart';
import 'package:names_app/ui_screens/fav_names_screen.dart';
import 'package:names_app/ui_screens/names/all_names/all_names_selection_screen.dart';
import 'package:names_app/ui_screens/names/celebrity_names/celebrity_names_selection_screen.dart';
import 'package:names_app/ui_screens/names/popular_names/popular_names_selection_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:store_redirect/store_redirect.dart';
import '../DataBase/SharedPrefrences.dart';
import '../main.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  int? isHomeScreenOpen = 0;
  HomeScreen({
    super.key,
    this.isHomeScreenOpen,
  });

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
      SizedBox(height: 5),
      Text(
        'Browse',
        style: TextStyle(fontSize: 12),
      ),
    ],
  );

  List<NameModel> listofNames = [];
  List<NameModel> namemodel = [];
  String? names;

  String? gender;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
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
    // showDialogue();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      drawer: const MyDrawerWidget(),
      appBar: AppBar(
        title: ListTile(
          title: TextField(
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (name) {
              setState(() {
                names = name.isEmpty ? '' : name;

                listofNames = namemodel
                    .where((element) => element.englishName!.contains(names!))
                    .toList();

                // and when the name is empty, then it will show all the names
                if (name.isEmpty) {
                  listofNames = namemodel;
                }
              });
            },
            decoration: const InputDecoration(
              suffixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              hintText: 'Type Name',
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
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
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage("assets/w.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocBuilder<NamesBloc, NamesState>(builder: (context, state) {
          if (state is NamesLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                strokeWidth: 10,
                strokeCap: StrokeCap.round,
              ),
            );
          } else if (state is NamesSuccess) {
            namemodel = state.filteredList!;
            String genderIcon = "";
            state.filteredList![0].gender == "Male" ||
                    state.filteredList![0].gender == "Boy" ||
                    state.filteredList![0].gender == "Larka"
                ? genderIcon = "👨"
                : genderIcon = "👩";
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
                            "$genderIcon ${listofNames[index].englishName}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                  state.filteredList![0].gender == "Male" ||
                          state.filteredList![0].gender == "Boy" ||
                          state.filteredList![0].gender == "Larka"
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
                                  isPageOpen: widget.isHomeScreenOpen,
                                  model: state.filteredList![index],
                                ),
                              ),
                            );
                          },
                          title: Text(
                            "$genderIcon ${state.filteredList![index].englishName}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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

class MyDrawerWidget extends StatelessWidget {
  const MyDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 58, 2, 68),
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
            title: const Row(
              children: [
                Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const GenderSelectionScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Favourite',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FavouritesScreen()));
            },
          ),
          ListTile(
            title: Row(
              children: [
                Image.asset(
                  "assets/popular.png",
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                const Text(
                  'All Names',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const AllNamesSelectionScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: Row(
              children: [
                Image.asset(
                  "assets/trending.png",
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Trending Names',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const PopularNamesSelectionScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Celebrities Names',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const CelebrityNamesSelectionScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
