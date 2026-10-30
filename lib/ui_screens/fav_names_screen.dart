//  ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:names_app/Bloc/FavouriteBloc/favourite_bloc.dart';
import 'package:names_app/Model/names_model.dart';
import 'package:names_app/theme/app_theme.dart';
import 'package:names_app/widgets/islamic_pattern.dart';
import 'package:names_app/widgets/name_tile.dart';
import 'detail_screen.dart';

/// Saved names. Lives as a tab inside the main shell.
class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavouriteBloc>().add(GetFavourites());
  }

  void _open(NameModel name) {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(builder: (_) => DetailPage(model: name)),
        )
        // Un-favouriting inside the detail page should reflect right away.
        .then((_) {
      if (mounted) context.read<FavouriteBloc>().add(GetFavourites());
    });
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return BlocBuilder<FavouriteBloc, FavouriteState>(
      builder: (context, state) {
        final names = state is FavouriteSuccess ? state.model : <NameModel>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PatternedGradient(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppSpacing.radiusLg + 8),
              ),
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                top + AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Favourites',
                          style:
                              Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          state is FavouriteSuccess
                              ? (names.isEmpty
                                  ? 'Names you love will appear here.'
                                  : '${names.length} saved ${names.length == 1 ? 'name' : 'names'}')
                              : 'Loading your names…',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _body(context, state, names)),
          ],
        );
      },
    );
  }

  Widget _body(BuildContext context, FavouriteState state, List<NameModel> names) {
    if (state is! FavouriteSuccess) {
      return const Center(child: CircularProgressIndicator());
    }
    if (names.isEmpty) return const _EmptyFavourites();

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: names.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final name = names[index];
        return NameTile(
          name: name,
          onTap: () => _open(name),
          trailing: const Icon(
            Icons.favorite_rounded,
            size: 20,
            color: Color(0xFFE5486E),
          ),
        );
      },
    );
  }
}

class _EmptyFavourites extends StatelessWidget {
  const _EmptyFavourites();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 44,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No favourites yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'Tap the heart on any name to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
