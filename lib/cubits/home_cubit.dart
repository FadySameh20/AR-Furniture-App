import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/offers_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/name_model.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit():super(InitialHomeState());

  List<Offers> offers=[];
  List<CategoryItem> categories=[];
   getAllData() async{
    await getCategoryNames();
    await getOffers();
  }
  getCategoryNames()async{
     FirebaseFirestore.instance.collection("names").get().then((value) {
       value.docs.forEach((element) {
         categories.add(CategoryItem.fromJson(element.data()));
       });
     }).catchError((error){});
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

}