import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:names_app/Bloc/NameBloc/names_bloc.dart';
import 'package:names_app/Model/names_model.dart';
import 'package:names_app/ui_screens/home_screen.dart';
import 'package:names_app/ui_screens/names/all_names/all_names_selection_screen.dart';
import 'package:names_app/ui_screens/names/celebrity_names/celebrity_names_selection_screen.dart';
import 'package:names_app/ui_screens/names/popular_names/popular_names_selection_screen.dart';

/// Which collection of names the user is browsing.
enum NameCategory {
  all(
    title: 'All Names',
    subtitle: '20,000+ names with meanings',
    boys: 'Male',
    girls: 'Female',
    icon: Icons.menu_book_rounded,
  ),
  trending(
    title: 'Trending Names',
    subtitle: 'Most loved right now',
    boys: 'Boy',
    girls: 'Girl',
    icon: Icons.trending_up_rounded,
  ),
  celebrity(
    title: 'Celebrity Names',
    subtitle: 'Inspired by public figures',
    boys: 'Larka',
    girls: 'Larki',
    icon: Icons.auto_awesome_rounded,
  );

  const NameCategory({
    required this.title,
    required this.subtitle,
    required this.boys,
    required this.girls,
    required this.icon,
  });

  final String title;
  final String subtitle;

  /// Gender keys understood by [NamesBloc] for this collection.
  final String boys;
  final String girls;
  final IconData icon;

  Widget get pickerScreen => switch (this) {
        NameCategory.all => const AllNamesSelectionScreen(),
        NameCategory.trending => const PopularNamesSelectionScreen(),
        NameCategory.celebrity => const CelebrityNamesSelectionScreen(),
      };
}

/// Loads [gender]'s names from the bloc and opens the browsable list.
void openNameList(
  BuildContext context, {
  required NameCategory category,
  required bool boys,
}) {
  final bloc = context.read<NamesBloc>();
  final state = bloc.state;
  final List<NameModel>? existing = state is NamesSuccess ? state.model : null;
  final gender = boys ? category.boys : category.girls;

  bloc.add(GetNamesOnGender(gender: gender, list: existing));
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => HomeScreen(
        title: category.title,
        subtitle: boys ? 'Boys' : 'Girls',
        isBoys: boys,
      ),
    ),
  );
}

/// Shared page transition for moving between top-level flows.
Route<T> fadeRoute<T>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
