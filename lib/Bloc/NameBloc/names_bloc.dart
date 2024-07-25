// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:names_app/DataBase/Converter.dart';
import 'package:names_app/DataBase/SharedPrefrences.dart';
import 'package:names_app/DataBase/dataBase.dart';
import 'package:names_app/Model/names_model.dart';
part 'names_event.dart';
part 'names_state.dart';

class NamesBloc extends Bloc<NamesEvent, NamesState> {
  NamesBloc() : super(NamesInitial()) {
    SqlLiteDb obj = SqlLiteDb();
    on<GetNames>(
      (event, emit) async {
        emit(NamesLoading());
        List<NameModel> list = [];
        bool? isViewed =
            await SharedPreference.getbool(SharedPreference.isViewed);
        if (isViewed == true) {
          list = await obj.getItems();
          emit(NamesSuccess(model: list));
        } else {
          // var fenaledata = await jsonDecode(maleresponse);
          //  list = await fireBase.getData();
          //  Future.delayed(Duration(seconds: 4), () async {
          obj.createItem(model: list);
          await SharedPreference.savebool(SharedPreference.isViewed, true);
          emit(
            NamesSuccess(
              model: list,
            ),
          );
          //  });
        }
      },
    );
    on<RefreshNames>(
      (event, emit) async {
        emit(NamesLoading());

        List<NameModel> gendermodel = [];
        List<NameModel> combinelist = [];

        List<NameModel>? list = [];

        if (event.gender == "Male") {
          var maleresponse = await rootBundle.loadString('assets/Male.json');
          final malepraser = DataParser(encodedJson: maleresponse);
          gendermodel = await malepraser.parseInBackground();
        } else {
          var femaleresponse = await rootBundle.loadString('assets/Girls.json');
          final femalepraser = DataParser(encodedJson: femaleresponse);
          gendermodel = await femalepraser.parseInBackground();
        }

        var existingItems = await obj.getItems();
        if (existingItems != null) {
          var filteredlist =
              list.where((element) => existingItems.contains(element)).toList();
          if (filteredlist.isNotEmpty) {
            obj.createItem(model: filteredlist);
          }
        }

        combinelist = [gendermodel, list].expand((data) => data).toList();
        var filteredList = combinelist
            .where((element) => element.gender == event.gender)
            .toList();

        emit(NamesSuccess(filteredList: filteredList, model: list));
      },
    );
    on<GetNamesOnGender>(
      (event, emit) async {
        emit(NamesLoading());
        List<NameModel> gendermodel = [];
        List<NameModel> combinelist = [];

        if (event.gender == "Male") {
          var maleresponse = await rootBundle.loadString('assets/Male.json');
          final malepraser = DataParser(encodedJson: maleresponse);
          gendermodel = await malepraser.parseInBackground();
        } else {
          var femaleresponse = await rootBundle.loadString('assets/Girls.json');
          final femalepraser = DataParser(encodedJson: femaleresponse);
          gendermodel = await femalepraser.parseInBackground();
        }
        combinelist = [
          gendermodel,
        ].expand((data) => data).toList();

        List<NameModel>? list = await obj.getItems();
        var filteredList = combinelist
            .where((element) => element.gender == event.gender)
            .toList();
        emit(NamesSuccess(filteredList: filteredList, model: list));
      },
    );
  }
}
