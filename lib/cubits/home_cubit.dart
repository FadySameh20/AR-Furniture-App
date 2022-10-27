import 'dart:convert';

import 'dart:ui';

import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/models/offers_model.dart';
import 'package:ar_furniture_app/models/shared_model.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  CacheModel? cacheModel;
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

  updateCart() {
    if (cache!="") {
      Map<String, dynamic> cart = cacheModel!.cachedModel[0].cartMap;
      // List<SharedModel> shared = [];
      for (int i = 0; i < furnitureList.length; i++) {
        if (cart.keys.contains(furnitureList[i].furnitureId)) {
          // for (int j = 0; j < furnitureList[i].shared.length; j++) {
          //   shared.add(cart[furnitureList[i].furnitureId][j]);
          // }
          for (int j = 0; j < furnitureList[i].shared.length; j++) {
            if (int.parse(cart[furnitureList[i].furnitureId][j].quantityCart) >
                0) {
              furnitureList[i].shared[j].quantityCart =
                  cart[furnitureList[i].furnitureId][j].quantityCart;
            }
          }
        }
      }
    }
  }

  addToCart(String furnitureId, int selectedIndex, int cartQuantity) async {
    int index = furnitureList
        .indexWhere((element) => element.furnitureId == furnitureId);
    furnitureList[index].shared[selectedIndex].quantityCart =
        cartQuantity.toString();
    emit(SuccessOffersState());
    var cachedtemp = cacheModel!.cachedModel.where(
        (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);
    CachedUserModel cachedModel;
    cachedModel = cachedtemp.first;
    print("Before");
    print(cacheModel!.cachedModel[0].cartMap);
    if (!cacheModel!.cachedModel[0].cartMap.keys.contains(furnitureId)) {
      cachedModel.cartMap[furnitureId] = furnitureList[index].shared;
    } else {
      cacheModel!.cachedModel[0].cartMap[furnitureId][selectedIndex]
          .quantityCart = cartQuantity.toString();
    }
    CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));
    print("After");
    print(cacheModel!.cachedModel[0].cartMap);
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
          cachedUser: UserModel.fromJson(temp.data()!),
          cartMap: {})
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
            cachedUser: UserModel.fromJson(temp.data()!),
            cartMap: {}));
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

  addOrRemoveFromFavorite(index) async {
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
  Map<String, dynamic> cartMap = {};

  // List<CartModel> cartModels = [];
  late UserModel cachedUser;

  // late CartModel cachedCart;
  CachedUserModel(
      {required this.uid,
      required this.cachedFavoriteIds,
      required this.cachedUser,
      required this.cartMap});

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

    // cartMap = json["cartData"];

    json["cartData"].forEach((key, value) {
      List<SharedModel> shared = [];
      value.forEach((element) {
        SharedModel tempShared = SharedModel.fromJson(element);
        tempShared.quantityCart = element['quantityCart'];
        shared.add(tempShared);
      });
      cartMap[key] = shared;
    });
  }

  Map toMap() {
    Map<String, dynamic> tempCartMap = {};
    List<Map<String, dynamic>> tempSharedList = [];
    cartMap.forEach((key, value) {
      value.forEach((element) {
        Map<String, dynamic> tempSharedMap = element.toMap();
        tempSharedMap['quantityCart'] = element.quantityCart;
        tempSharedList.add(tempSharedMap);
      });
      tempCartMap[key] = tempSharedList;
    });

    return {
      "uid": uid,
      "cachedFavoriteIds": cachedFavoriteIds,
      "userData": cachedUser.toMap(),
      "cartData": tempCartMap
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
