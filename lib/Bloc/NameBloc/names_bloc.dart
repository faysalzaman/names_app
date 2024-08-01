// ignore_for_file: unnecessary_null_comparison, avoid_print

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
            NamesSuccess(model: list),
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
        } else if (event.gender == "Female") {
          var femaleresponse = await rootBundle.loadString('assets/Girls.json');
          final femalepraser = DataParser(encodedJson: femaleresponse);
          gendermodel = await femalepraser.parseInBackground();
        } else if (event.gender == "Boy") {
          try {
            var boysResponse = await rootBundle.loadString('assets/TBoys.json');
            if (boysResponse != null) {
              final femalepraser = DataParser(encodedJson: boysResponse);
              gendermodel = await femalepraser.parseInBackground();
              print("Data loaded successfully for TBoys.");
            } else {
              print("No data found for TBoys.");
            }
          } catch (e) {
            print("Error loading data for TBoys: $e");
          }
        } else if (event.gender == "Females") {
          try {
            var girlsResponse =
                await rootBundle.loadString('assets/TGirls.json');
            if (girlsResponse != null) {
              final femalepraser = DataParser(encodedJson: girlsResponse);
              gendermodel = await femalepraser.parseInBackground();
              print("Data loaded successfully for TGirls.");
            } else {
              print("No data found for TGirls.");
            }
          } catch (e) {
            print("Error loading data for TGirls: $e");
          }
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
        } else if (event.gender == "Female") {
          var femaleresponse = await rootBundle.loadString('assets/Girls.json');
          final femalepraser = DataParser(encodedJson: femaleresponse);
          gendermodel = await femalepraser.parseInBackground();
        } else if (event.gender == "Boy") {
          var maleresponse = await rootBundle.loadString('assets/TBoys.json');
          print(maleresponse);
          try {
            final malepraser = DataParser(encodedJson: maleresponse);
            gendermodel = await malepraser.parseInBackground();
            print(gendermodel);
          } catch (error) {
            print(error);
          }
        } else if (event.gender == "Female") {
          try {
            var femaleresponse =
                await rootBundle.loadString('assets/TGirls.json');
            if (femaleresponse != null) {
              final femalepraser = DataParser(encodedJson: femaleresponse);
              gendermodel = await femalepraser.parseInBackground();
              print("Data loaded successfully for TGirls.");
            } else {
              print("No data found for TGirls.");
            }
          } catch (e) {
            print("Error loading data for TGirls: $e");
          }
        }

        combinelist = [gendermodel].expand((data) => data).toList();

        List<NameModel>? list = await obj.getItems();

        var filteredList = combinelist
            .where((element) => element.gender == event.gender)
            .toList();

        emit(NamesSuccess(filteredList: filteredList, model: list));
        // emit(NamesSuccess(filteredList: filteredList, model: gendermodel));
      },
    );
  }
}
