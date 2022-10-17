import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/models/offers_model.dart';
import 'package:ar_furniture_app/models/shared_model.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/name_model.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit():super(InitialHomeState());

  List<Offers> offers=[];
  List<CategoryItem> categories=[];
  List<FurnitureModel> furnitureList=[];
   getAllData() async{
    await getCategoryNames();
    await getOffers();
  }
  getCategoryNames()async{
     Category myCategory=Category([]);
    await FirebaseFirestore.instance.collection("names").get().then((value) {
       value.docs.forEach((element) {
         myCategory=Category.fromJson(element.data());
       });
       categories=List.from(myCategory.names);
     }).catchError((error){});
    print(categories.length);
    for(var i in categories){
      if(i.name=="beds") {
        getFurniture(i.name);
      }
    }
   }
   getOffers() async {
    await FirebaseFirestore.instance.collection('offer')
        .get().then((value){
          value.docs.forEach((element) {
            offers.add(Offers.fromJson(element.data()));
          });
          emit(SuccessOffersState());
    }).catchError((error){emit(ErrorOffersState());});
    print(offers.length);
  }

  getFurniture(String categoryName)async{
     // FurnitureModel myFurniture=FurnitureModel(furnitureId:'', name: '', model: '', shared: []);
    // print(CacheHelper.getData("favorites"));
    // CacheHelper.removeData("favorites");
    List favoritesId=await CacheHelper.getData("favorites")??[];
    print(favoritesId);
     await FirebaseFirestore.instance.collection('category').doc(categoryName).collection(categoryName).get().then((value) {
       value.docs.forEach((element) {

        FurnitureModel myFurniture = FurnitureModel.fromJson(element.data());
         furnitureList.add(myFurniture);
          if(favoritesId.contains(myFurniture.furnitureId)){
            furnitureList.last.isFavorite=true;
            // favorites.add(myFurniture);
          }
       });


     });

print(furnitureList.length);

  }

}