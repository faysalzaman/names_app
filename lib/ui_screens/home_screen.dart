//  ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/Model/name_model_x.dart';
import 'package:names_app/Model/names_model.dart';
import 'package:names_app/theme/app_theme.dart';
import 'package:names_app/widgets/banner_ad_widget.dart';
import 'package:names_app/widgets/islamic_pattern.dart';
import 'package:names_app/widgets/name_tile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'detail_screen.dart';

/// Browsable, searchable list of names with an A–Z index rail.
class HomeScreen extends StatefulWidget {
  final int? isHomeScreenOpen;
  final String? title;
  final String? subtitle;
  final bool? isBoys;

  const HomeScreen({
    super.key,
    this.isHomeScreenOpen,
    this.title,
    this.subtitle,
    this.isBoys,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _railItemHeight = 18.0;

  List<NameModel> _all = [];
  List<NameModel> _filtered = [];
  List<String> _alphabet = [];
  String _query = '';

  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _positionsListener =
      ItemPositionsListener.create();
  final ValueNotifier<String?> _selectedLetter = ValueNotifier<String?>(null);

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _positionsListener.itemPositions.addListener(_updateLetterOnScroll);
  }

  @override
  void dispose() {
    _positionsListener.itemPositions.removeListener(_updateLetterOnScroll);
    _searchController.dispose();
    _selectedLetter.dispose();
    super.dispose();
  }

  void _syncWith(List<NameModel> source) {
    if (identical(source, _all)) return;
    _all = source;
    _applyFilter();
  }

  void _applyFilter() {
    final q = _query.toLowerCase();
    _filtered = q.isEmpty
        ? List.of(_all)
        : _all
            .where((n) => (n.englishName ?? '').toLowerCase().contains(q))
            .toList();
    _alphabet = _filtered
        .map((n) => n.initial)
        .toSet()
        .toList()
      ..sort();
  }

  void _onSearch(String value) {
    setState(() {
      _query = value.trim();
      _applyFilter();
      _selectedLetter.value = null;
    });
  }

  void _scrollToLetter(String letter) {
    final index = _filtered.indexWhere((n) => n.initial == letter);
    if (index == -1) return;
    _selectedLetter.value = letter;
    _scrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOutCubic,
    );
  }

  void _updateLetterOnScroll() {
    final positions = _positionsListener.itemPositions.value
        .where((p) => p.itemTrailingEdge > 0);
    if (positions.isEmpty || _filtered.isEmpty) return;

    final first = positions
        .reduce((a, b) => b.itemLeadingEdge < a.itemLeadingEdge ? b : a)
        .index;
    if (first >= _filtered.length) return;

    final letter = _filtered[first].initial;
    if (letter != _selectedLetter.value) _selectedLetter.value = letter;
  }

  void _onRailTouch(double dy) {
    if (_alphabet.isEmpty) return;
    final i = (dy / _railItemHeight).floor().clamp(0, _alphabet.length - 1);
    _scrollToLetter(_alphabet[i]);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.title ?? 'Names';
    final accent = widget.isBoys == false ? NameTile.girlColor : NameTile.boyColor;

    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            title: title,
            subtitle: widget.subtitle,
            controller: _searchController,
            onChanged: _onSearch,
            onClear: () {
              _searchController.clear();
              _onSearch('');
            },
            query: _query,
          ),
          Expanded(
            child: BlocBuilder<NamesBloc, NamesState>(
              builder: (context, state) {
                if (state is NamesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is NamesSuccess) {
                  _syncWith(state.filteredList ?? const []);
                  if (_filtered.isEmpty) {
                    return _EmptyState(searching: _query.isNotEmpty);
                  }
                  return _buildList(accent);
                }
                return const _EmptyState(searching: false);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(Color accent) {
    return Stack(
      children: [
        ScrollablePositionedList.builder(
          itemCount: _filtered.length,
          itemScrollController: _scrollController,
          itemPositionsListener: _positionsListener,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl + 8,
            AppSpacing.md,
          ),
          itemBuilder: (context, index) {
            final name = _filtered[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: RepaintBoundary(
                child: NameTile(
                  name: name,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => DetailPage(
                        isPageOpen: widget.isHomeScreenOpen,
                        model: name,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          right: 4,
          top: 0,
          bottom: 0,
          child: Center(child: _buildRail(accent)),
        ),
      ],
    );
  }

  Widget _buildRail(Color accent) {
    final scheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<String?>(
      valueListenable: _selectedLetter,
      builder: (context, selected, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => _onRailTouch(d.localPosition.dy),
              onVerticalDragUpdate: (d) => _onRailTouch(d.localPosition.dy),
              child: Container(
                width: 24,
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final letter in _alphabet)
                      SizedBox(
                        height: _railItemHeight,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 120),
                            style: TextStyle(
                              fontSize: selected == letter ? 13 : 11,
                              fontWeight: selected == letter
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: selected == letter
                                  ? scheme.primary
                                  : scheme.onSurface.withValues(alpha: 0.5),
                            ),
                            child: Text(letter),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.subtitle,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.query,
  });

  final String title;
  final String? subtitle;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String query;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return PatternedGradient(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(AppSpacing.radiusLg),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sm,
        top + AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
                color: Colors.white,
                tooltip: 'Back',
              ),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                ),
              ),
              if (subtitle != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    subtitle!,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Search a name…',
                hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.45)),
                prefixIcon:
                    const Icon(Icons.search_rounded, color: AppColors.plumMid),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        color: Colors.black45,
                        onPressed: onClear,
                      ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.searching});

  final bool searching;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              searching ? Icons.search_off_rounded : Icons.inbox_outlined,
              size: 56,
              color: scheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              searching ? 'No names match your search' : 'No names found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              searching
                  ? 'Try a different spelling.'
                  : 'Go back and pick another collection.',
              style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
