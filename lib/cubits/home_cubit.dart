import 'dart:convert';

import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/models/offers_model.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/name_model.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialHomeState());

  List<Offers> offers = [];
  List<CategoryItem> categories = [];
  List<FurnitureModel> furnitureList = [];

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
    var cache=await getCache();
    List favoritesId;
    if(cache=="") {
      favoritesId=[];
    } else {
      favoritesId=cache.cachedFavoriteIds;
    }
    print(favoritesId);
    await FirebaseFirestore.instance
        .collection('category')
        .doc(categoryName)
        .collection(categoryName)
        .get()
        .then((value) {
      for (var element in value.docs) {
        FurnitureModel myFurniture = FurnitureModel.fromJson(element.data());
        furnitureList.add(myFurniture);
        if (favoritesId.contains(myFurniture.furnitureId)) {
          furnitureList.last.isFavorite = true;
        }
      }
    });

    print(furnitureList.length);
  }














































  CacheModel? cacheModel;
  logout(context){
    FirebaseAuth.instance.signOut();
    emit(SuccessOffersState());
    Navigator.pushNamed(context, "/");
  }

  createCache() async{
    cacheModel=CacheModel(cachedModel: [CachedUserModel(uid: FirebaseAuth.instance.currentUser!.uid, cachedFavoriteIds: [])]);
  }

  getCache() async {
    var temp = await CacheHelper.getData("user") ?? "";
    if (temp != "") {
      Map cachedMap = jsonDecode(temp);
      print(cachedMap);
      cacheModel = CacheModel.fromJson(cachedMap);
      var isUserCached = cacheModel!.cachedModel.where(
              (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);
      // CachedUserModel cache;
      if(isUserCached.isEmpty) {
        return "";
      } else {
        return isUserCached.first;
      }
    }
    return "";
  }

  addOrRemoveFromFavorite(index){
    furnitureList[index].isFavorite=!furnitureList[index].isFavorite;
    emit(SuccessOffersState());
    if(furnitureList[index].isFavorite==true){
      if(cacheModel==null){
        createCache();
      }
      var cachedtemp=cacheModel!.cachedModel.where((element) => element.uid==FirebaseAuth.instance.currentUser!.uid);
      CachedUserModel cachedModel;
      if(cachedtemp.isEmpty){
        cachedModel=CachedUserModel(uid: FirebaseAuth.instance.currentUser!.uid, cachedFavoriteIds: []);
        cacheModel!.cachedModel.add(cachedModel);
      }
      else{
        cachedModel=cachedtemp.first;
      }
      cachedModel.cachedFavoriteIds.add(furnitureList[index].furnitureId);
      CacheHelper.setData( key: 'user', value: jsonEncode(cacheModel!.toMap()));
    }else{
      var cachedModel=cacheModel!.cachedModel.where((element) => element.uid==FirebaseAuth.instance.currentUser!.uid).first;
      cachedModel.cachedFavoriteIds.remove(furnitureList[index].furnitureId);
      // print(jsonEncode(BlocProvider.of<HomeCubit>(context).cacheModel!.toMap()));
      CacheHelper.setData( key: 'user', value: jsonEncode(cacheModel!.toMap()));
    }
  }
}

class CacheModel {
  List<CachedUserModel> cachedModel = [];

  CacheModel({required this.cachedModel});

  CacheModel.fromJson(json) {
    json["cachedModel"].forEach((element) {
      cachedModel.add(CachedUserModel.fromJson(element));
    });
  }

  Map toMap() {
    return {"cachedModel": cachedModel.map((e) => e.toMap()).toList()};
  }
}

class CachedUserModel {
  late String uid;
  List<String> cachedFavoriteIds = [];

  CachedUserModel({required this.uid, required this.cachedFavoriteIds});

  CachedUserModel.fromJson(Map json) {
    uid = json["uid"];
    json["cachedIds"].forEach((element){
      cachedFavoriteIds.add(element);
    });
  }

  Map toMap() {
    return {"uid": uid, "cachedIds": cachedFavoriteIds};
  }
}
