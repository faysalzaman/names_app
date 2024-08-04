// ignore_for_file: must_be_immutable

part of 'favourite_bloc.dart';

@immutable
abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoading extends FavouriteState {}

class FavouriteSuccess extends FavouriteState {
  final List<NameModel> model;

  // Constructor requires a non-null list of NameModel objects
  FavouriteSuccess({required this.model});
}
