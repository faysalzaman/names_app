// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unnecessary_null_comparison, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/Model/names_model.dart';
import 'package:names_app/ui_screens/names/GenderSelectionScreen.dart';
import 'package:names_app/ui_screens/fav_names_screen.dart';
import 'package:names_app/ui_screens/names/all_names/all_names_selection_screen.dart';
import 'package:names_app/ui_screens/names/celebrity_names/celebrity_names_selection_screen.dart';
import 'package:names_app/ui_screens/names/popular_names/popular_names_selection_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:store_redirect/store_redirect.dart';
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
  List<NameModel> namemodel = [];
  List<NameModel> filteredNames = [];
  String? searchQuery;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  List<String> alphabet = [];
  String? selectedLetter;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
    itemPositionsListener.itemPositions
        .addListener(_updateSelectedLetterOnScroll);
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions
        .removeListener(_updateSelectedLetterOnScroll);
    super.dispose();
  }

  void _initBannerAd() {
    // ... (keep the existing ad initialization code)
  }

  void _filterNames(String query) {
    setState(() {
      searchQuery = query.isEmpty ? null : query;
      if (searchQuery == null) {
        filteredNames = List.from(namemodel);
      } else {
        filteredNames = namemodel
            .where((name) => name.englishName!
                .toLowerCase()
                .contains(searchQuery!.toLowerCase()))
            .toList();
      }
      _updateAlphabet();
      selectedLetter = null;
    });
  }

  void _updateAlphabet() {
    alphabet = filteredNames
        .map((name) => name.englishName![0].toUpperCase())
        .toSet()
        .toList()
      ..sort();
  }

  void _scrollToLetter(String letter) {
    final index = filteredNames.indexWhere(
        (name) => name.englishName!.toUpperCase().startsWith(letter));
    if (index != -1) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
      setState(() {
        selectedLetter = letter;
      });
    }
  }

  void _updateSelectedLetterOnScroll() {
    if (itemPositionsListener.itemPositions.value.isNotEmpty) {
      int firstVisibleItemIndex = itemPositionsListener.itemPositions.value
          .where((ItemPosition position) => position.itemTrailingEdge > 0)
          .reduce((ItemPosition min, ItemPosition position) =>
              position.itemLeadingEdge < min.itemLeadingEdge ? position : min)
          .index;

      String currentLetter =
          filteredNames[firstVisibleItemIndex].englishName![0].toUpperCase();
      if (currentLetter != selectedLetter) {
        setState(() {
          selectedLetter = currentLetter;
        });
      }
    }
  }

  // scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      drawer: const MyDrawerWidget(),
      appBar: AppBar(
          // ... (keep the existing AppBar code)
          ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.5,
            image: AssetImage("assets/w.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocBuilder<NamesBloc, NamesState>(
          builder: (context, state) {
            if (state is NamesLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.purple)));
            } else if (state is NamesSuccess) {
              namemodel = state.filteredList!;
              if (filteredNames.isEmpty) filteredNames = List.from(namemodel);
              _updateAlphabet();

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Main list of names
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      itemCount: filteredNames.length,
                      itemBuilder: (context, index) {
                        final name = filteredNames[index];
                        final genderIcon = name.gender == "Male" ||
                                name.gender == "Boy" ||
                                name.gender == "Larka"
                            ? "👨"
                            : "👩";
                        return ListTile(
                          title: Text(
                            "$genderIcon ${name.englishName}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                    isPageOpen: widget.isHomeScreenOpen,
                                    model: name)),
                          ),
                        );
                      },
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: MediaQuery.of(context).size.height * 1,
                    alignment: Alignment.center,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (var letter in alphabet)
                          GestureDetector(
                            onTap: () => _scrollToLetter(letter),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 20,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selectedLetter == letter
                                      ? Colors.purple.withOpacity(0.3)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: selectedLetter == letter
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.7),
                                    fontWeight: selectedLetter == letter
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const Center(
                child: Text('No Data Found',
                    style: TextStyle(color: Colors.white)));
          },
        ),
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
