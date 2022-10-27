import 'dart:convert';

import 'dart:ui';

import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/models/offers_model.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/name_model.dart';
import '../models/user_model.dart';
import '../shared/cache/sharedpreferences.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialHomeState());

  List<Offers> offers = [];
  List<CategoryItem> categories = [];
  List<FurnitureModel> furnitureList = [];
  List<String> returnedCategory = [];
  List<Color?> availableColors = [];

  var cache;

  getAllData() async {
    // await createCache();
    await getCategoryNames();
    await getOffers();
    if (FirebaseAuth.instance.currentUser != null) {
      cache = await getCache();
    } else {
      cache = "";
    }
    print(FirebaseAuth.instance.currentUser!.uid);
    // print(cacheModel.cachedModel.where((element) => ))
    await getFurniture(categories.first.name);
  }

  setCache() async {
    cache = await getCache();
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

    List favoritesId;
    if (cache == "") {
      favoritesId = [];
    } else {
      favoritesId = cache.cachedFavoriteIds;
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
    emit(SuccessOffersState());
    print(furnitureList.length);
  }

  Color? getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return null;
  }

  List<Color?> getAvailableColorsOfFurniture(FurnitureModel selectedFurniture) {
    availableColors.clear();
    for (int i = 0; i < selectedFurniture.shared.length; i++) {
      availableColors.add(getColorFromHex(selectedFurniture.shared[i].color));
    }
    return availableColors;
  }


  CacheModel? cacheModel;

  logout(context) async {
    for (int i = 0; i < furnitureList.length; i++) {
      furnitureList[i].isFavorite = false;
    }
    await FirebaseAuth.instance.signOut();
    // emit(SuccessOffersState());
    Navigator.pushReplacementNamed(context, "/");
  }

  updateFavoriteList() {
    if (cache!="") {
      List favoritesId = cache.cachedFavoriteIds;
      for (int i = 0; i < furnitureList.length; i++) {
        if (favoritesId.contains(furnitureList[i].furnitureId)) {
          furnitureList[i].isFavorite = true;
        }
      }
    }
  }

  createCache() async {
    var temp = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    cacheModel = CacheModel(cachedModel: [
      CachedUserModel(
          uid: FirebaseAuth.instance.currentUser!.uid,
          cachedFavoriteIds: [],
          cachedUser: UserModel.fromJson(temp.data()!))
    ]);
    CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));
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
      if (isUserCached.isEmpty) {
        var temp = await FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        print(temp.data()!["fName"]);
        cacheModel!.cachedModel.add(CachedUserModel(
            uid: FirebaseAuth.instance.currentUser!.uid,
            cachedFavoriteIds: [],
            cachedUser: UserModel.fromJson(temp.data()!)));
        print(cacheModel!.cachedModel.last.cachedUser.fName);
        // var cachedModel=cacheModel!.cachedModel.where((element) => element.uid==FirebaseAuth.instance.currentUser!.uid).first;
        // cachedModel.cachedFavoriteIds.remove(furnitureList[index].furnitureId);
        // print(jsonEncode(BlocProvider.of<HomeCubit>(context).cacheModel!.toMap()));
        CacheHelper.setData(
            key: 'user', value: jsonEncode(cacheModel!.toMap()));
        return "";
      } else {
        return isUserCached.first;
      }
    } else {
      createCache();
    }
    return "";
  }

  updateUserData(context,fName, lName, address, phone, {email,password,newPassword=""}) async {
    emit(UpdateLoadingState());
    int flag = 0;
    var temp = cacheModel!.cachedModel.where(
            (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);
    if(newPassword!=""){
      flag=2;
      AuthCredential credential = EmailAuthProvider.credential(
          email: temp.first.cachedUser.email, password: password);
     await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential( credential).then((value)async {
        await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
        emit(UpdatePasswordSuccessState());
      }).catchError((error){emit(UpdatePasswordErrorState("Incorrect email or password"));});
    }
    print(temp.first.cachedUser.email);
    print(email);
    if(temp.first.cachedUser.email!=email){
      flag=1;
      AuthCredential credential = EmailAuthProvider.credential(
          email: temp.first.cachedUser.email, password: password);
      await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential( credential).then((value)async {
        await FirebaseAuth.instance.currentUser?.updateEmail(email);
        temp.first.cachedUser.email=email;
        emit(UpdateEmailSuccessState());
      }).catchError((error){emit(UpdateEmailErrorState("Incorrect email or password"));});
     }



    if (temp.first.cachedUser.fName != fName) {
      temp.first.cachedUser.fName = fName;
      flag = 1;
    }
    if (temp.first.cachedUser.lName != lName) {
      temp.first.cachedUser.lName = lName;
      flag = 1;
    }
    if (temp.first.cachedUser.address != address) {
      temp.first.cachedUser.address = address;
      flag = 1;
    }
    if (temp.first.cachedUser.phone != phone) {
      temp.first.cachedUser.phone = phone;
      flag = 1;
    }
    if (flag == 1) {
      CacheHelper.setData(key: "user", value: jsonEncode(cacheModel!.toMap()));
      await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(temp.first.cachedUser.toMap()).then((value)
      {
        emit(UpdateUserDataSuccessData());
      }).catchError((error){

      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nothing to update")));
    }
  }

  addOrRemoveFromFavorite(furnId) async {
    int index=furnitureList.indexWhere((element) => element.furnitureId==furnId);
    furnitureList[index].isFavorite = !furnitureList[index].isFavorite;
    emit(SuccessOffersState());
    if (furnitureList[index].isFavorite == true) {
      // if(cacheModel==null){
      //   createCache();
      // }
      var cachedtemp = cacheModel!.cachedModel.where(
          (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);
      CachedUserModel cachedModel;
      cachedModel = cachedtemp.first;
      print(cachedModel.cachedUser.fName);
      cachedModel.cachedFavoriteIds.add(furnitureList[index].furnitureId);
      CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));
    } else {
      var cachedModel = cacheModel!.cachedModel
          .where((element) =>
              element.uid == FirebaseAuth.instance.currentUser!.uid)
          .first;
      cachedModel.cachedFavoriteIds.remove(furnitureList[index].furnitureId);
      // print(jsonEncode(BlocProvider.of<HomeCubit>(context).cacheModel!.toMap()));
      CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));
    }
  }

  void updateCartInFirestore(FurnitureModel selectedFurniture) async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc(selectedFurniture.category)
        .collection(selectedFurniture.category)
        .doc(selectedFurniture.furnitureId)
        .set(selectedFurniture.toMap())
        .then((value) => print("Updated"))
        .catchError((error) {
      print("Error");
      print(error);
    });
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
  late UserModel cachedUser;

  CachedUserModel(
      {required this.uid,
      required this.cachedFavoriteIds,
      required this.cachedUser});

  CachedUserModel.fromJson(Map json) {
    uid = json["uid"];
    print(json["cachedFavoriteIds"]);
    if (json["cachedFavoriteIds"] != null) {
      json["cachedFavoriteIds"].forEach((element) {
        cachedFavoriteIds.add(element);
      });
    } else {
      cachedFavoriteIds = [];
    }
    cachedUser = UserModel.fromJson(json["userData"]);
  }

  Map toMap() {
    return {
      "uid": uid,
      "cachedFavoriteIds": cachedFavoriteIds,
      "userData": cachedUser.toMap()
    };
  }

  void updateCartInFirestore(FurnitureModel selectedFurniture) async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc(selectedFurniture.category)
        .collection(selectedFurniture.category)
        .doc(selectedFurniture.furnitureId)
        .set(selectedFurniture.toMap())
        .then((value) => print("Updated"))
        .catchError((error) {
      print("Error");
      print(error);
    });
  }
}
