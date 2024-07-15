// ignore_for_file: must_be_immutable

part of 'names_bloc.dart';

abstract class NamesState {}

class NamesInitial extends NamesState {}

class NamesLoading extends NamesState {}

class NamesSuccess extends NamesState {
  String? name;
  List<NameModel>? model;
  List<NameModel>? filteredList;
  NamesSuccess({this.model, this.name, this.filteredList});
}
