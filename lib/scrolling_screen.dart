import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:flutter/material.dart';

class ScrollingScreen extends StatelessWidget {
  final List<String> items = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
    'Imbe',
    'Jackfruit',
    'Kiwi',
    'Lemon',
    'Mango',
    'Nectarine',
    'Orange',
    'Papaya',
    'Quince',
    'Raspberry',
    'Strawberry',
    'Tangerine',
    'Ugli fruit',
    'Vanilla bean',
    'Watermelon',
    'Ximenia caffra',
    'Yuzu',
    'Zucchini',
  ];

  ScrollingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('A-Z Scroll Example')),
      body: AlphaScroll(
        items: items,
        onSelected: (item) {
          print('Selected: $item');
          // You can add more functionality here, like scrolling to the item
        },
      ),
    );
  }
}

class AlphaScroll extends StatefulWidget {
  final List<String> items;
  final Function(String) onSelected;

  const AlphaScroll({
    Key? key,
    required this.items,
    required this.onSelected,
  }) : super(key: key);

  @override
  _AlphaScrollState createState() => _AlphaScrollState();
}

class _AlphaScrollState extends State<AlphaScroll> {
  late List<String> _alphabet;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _alphabet = _generateAlphabet();
  }

  List<String> _generateAlphabet() {
    List<String> uniqueLetters = widget.items
        .map((item) => item[0].toUpperCase())
        .toSet()
        .toList()
        .cast<String>();
    return uniqueLetters.toList()..sort();
  }

  void _scrollToIndex(int index) {
    itemScrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ScrollablePositionedList.builder(
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.items[index]),
                onTap: () => widget.onSelected(widget.items[index]),
              );
            },
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
          ),
        ),
        SizedBox(
          width: 40,
          child: ListView.builder(
            itemCount: _alphabet.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  final selectedLetter = _alphabet[index];
                  final selectedIndex = widget.items.indexWhere(
                    (item) => item.toUpperCase().startsWith(selectedLetter),
                  );
                  if (selectedIndex != -1) {
                    _scrollToIndex(selectedIndex);
                    widget.onSelected(widget.items[selectedIndex]);
                  }
                },
                child: Container(
                  height: 20,
                  alignment: Alignment.center,
                  child: Text(
                    _alphabet[index],
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
