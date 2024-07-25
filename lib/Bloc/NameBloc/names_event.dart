part of 'names_bloc.dart';

abstract class NamesEvent {}

class GetNames extends NamesEvent {}

class RefreshNames extends NamesEvent {
  String? gender;
  RefreshNames({this.gender});
}

class GetNamesOnGender extends NamesEvent {
  String? name;
  String? gender;
  List<NameModel>? list;

  GetNamesOnGender({
    this.gender,
    this.list,
    this.name,
  });
}
