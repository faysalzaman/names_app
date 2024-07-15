import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:names_app/DataBase/dataBase.dart';
import 'package:names_app/Model/names_model.dart';

part 'favourite_event.dart';
part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  SqlLiteDb obj = SqlLiteDb();
  FavouriteBloc() : super(FavouriteInitial()) {
    on<GetFavourites>((event, emit) async {
      List<NameModel> list = await obj.getFavouritesItems();
      list = list
          .where(
            (element) => element.isFavourite == "true",
          )
          .toList();
      emit(FavouriteSuccess(model: list));
    });
    on<AddtoFavourite>((event, emit) async {
      await obj.createFavouritesItem(model: event.model);
    });
  }
}
