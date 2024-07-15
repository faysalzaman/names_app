// ignore_for_file: must_be_immutable

part of 'favourite_bloc.dart';

@immutable
abstract class FavouriteEvent {}

class AddtoFavourite extends FavouriteEvent {
  NameModel? model;
  AddtoFavourite({this.model});
}

class GetFavourites extends FavouriteEvent {}
