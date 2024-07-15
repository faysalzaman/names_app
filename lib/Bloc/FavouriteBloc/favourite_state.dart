// ignore_for_file: must_be_immutable

part of 'favourite_bloc.dart';

@immutable
abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {}

class FavouriteSuccess extends FavouriteState {
  List<NameModel>? model;
  FavouriteSuccess({this.model});
}
