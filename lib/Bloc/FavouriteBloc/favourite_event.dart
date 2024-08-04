// ignore_for_file: must_be_immutable

part of 'favourite_bloc.dart';

@immutable
abstract class FavouriteEvent {}

class AddtoFavourite extends FavouriteEvent {
  final NameModel model;

  // Constructor requires a NameModel and marks it as final
  AddtoFavourite({required this.model});
}

class GetFavourites extends FavouriteEvent {}
