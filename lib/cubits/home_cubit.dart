import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/models/offers_model.dart';
import 'package:ar_furniture_app/models/shared_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/name_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialHomeState());


  List<Offers> offers = [];
  List<CategoryItem> categories = [];
  List<FurnitureModel> furnitureList = [];
  List<String> returnedCategory = [];
  List<FurnitureModel> allFurnitureList = [];

  getAllData() async {
    await getCategoryNames();
    await getOffers();
    await getFurniture(categories.first.name);
  }

  getCategoryNames() async {
    Category myCategory = Category([]);
    await FirebaseFirestore.instance.collection("names").get().then((value) {
      value.docs.forEach((element) {
        myCategory = Category.fromJson(element.data());
      });
      categories = List.from(myCategory.names);
    }).catchError((error) {});
    print(categories.length);
  }

  getOffers() async {
    await FirebaseFirestore.instance.collection('offer').get().then((value) {
      value.docs.forEach((element) {
        offers.add(Offers.fromJson(element.data()));
      });
      emit(SuccessOffersState());
    }).catchError((error) {
      emit(ErrorOffersState());
    });
    print(offers.length);
  }

  getFurniture(String categoryName) async {
    returnedCategory.add(categoryName);
    FurnitureModel myFurniture =
        FurnitureModel(furnitureId: '', name: '', model: '', shared: []);
    print("Here");
    await FirebaseFirestore.instance
        .collection('category')
        .doc(categoryName)
        .collection(categoryName)
        .get()
        .then((value) {
          value.docs.forEach((element) {
            print(element.data());
            myFurniture = FurnitureModel.fromJson(element.data());
            furnitureList.add(myFurniture);
          });

          emit(SuccessOffersState());
          print("Furniture List");
          print(furnitureList);
        });
  }
  getAllFurnitures() async {
    FurnitureModel myFurniture = FurnitureModel(furnitureId: '', name: '', model: '', shared: []);
    categories.forEach((categoryName) async {
      await FirebaseFirestore.instance
          .collection('category')
          .doc(categoryName.name)
          .collection(categoryName.name)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          print(element.data());
          myFurniture = FurnitureModel.fromJson(element.data());
          allFurnitureList.add(myFurniture);
        });
        emit(SuccessOffersState());
        print("All Furniture List");
        print(allFurnitureList);
      });
    });
  }

}
