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
  CacheModel? cacheModel;

  List<String> removeIds = [];
  List<String> unavailableQuantityFurniture = [];
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

  getSearchData(String searchbarName) async {
    print("get search dataaaaaaaa");
    print(furnitureList.map((e) => e.name).toList());
    print("--------------------------------");
    await FirebaseFirestore.instance.collectionGroup("furniture").where('name',whereNotIn:furnitureList.map((e) => e.name).toList()).where('name', isGreaterThanOrEqualTo: searchbarName, isLessThanOrEqualTo: '$searchbarName\uf8ff').limit(4).get().then((value) {
      value.docs.forEach((element) {
        print(element["name"]);
        furnitureList.add(FurnitureModel.fromJson(element.data()));
      });
    });
    print("Hellloooo");
    print(furnitureList.length);
    print(furnitureList.map((e) => e.name).toList());
    print("get search data 5alset");

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

      for (int j = 0; j < furnitureList[i].shared.length; j++) {
        furnitureList[i].shared[j].quantityCart = "0";
      }
    }
    await FirebaseAuth.instance.signOut();
    // emit(SuccessOffersState());
    Navigator.pushReplacementNamed(context, "/");
  }

  updateFavoriteList() {
    if (cache.cachedFavoriteIds.isNotEmpty) {
      List favoritesId = cache.cachedFavoriteIds;

      for (int i = 0; i < furnitureList.length; i++) {
        if (favoritesId.contains(furnitureList[i].furnitureId)) {
          furnitureList[i].isFavorite = true;
        }
      }
    }}
  updateCart() {
    if (cache.cartMap.isNotEmpty) {
      for (int i = 0; i < furnitureList.length; i++) {
        if (cache.cartMap.keys.contains(furnitureList[i].furnitureId)) {
          for (int j = 0; j < furnitureList[i].shared.length; j++) {
            if (int.parse(cache
                    .cartMap[furnitureList[i].furnitureId][j].quantityCart) >
                0) {
              furnitureList[i].shared[j].quantityCart =
                  cache.cartMap[furnitureList[i].furnitureId][j].quantityCart;
            }
          }
        }
      }
    }
  }

  removeFromCart(String furnitureId, String selectedColor) async {
    int index = furnitureList
        .indexWhere((element) => element.furnitureId == furnitureId);
    int selectedIndex = furnitureList[index]
        .shared
        .indexWhere((element) => element.color == selectedColor);
    furnitureList[index].shared[selectedIndex].quantityCart = '0';

    emit(SuccessOffersState());
    if (furnitureList[index].shared.length > 1) {
      cache.cartMap[furnitureId][selectedIndex].quantityCart = '0';
      int x = 0;
      cache.cartMap[furnitureId].forEach((element) {
        if (int.parse(element.quantityCart) == 0) {
          x += 1;
        }
      });
      if (x == cache.cartMap[furnitureId].length) {
        print('cart item no shared');
        cache.cartMap.removeWhere((key, value) => key == furnitureId);
      }
    } else {
      cache.cartMap
          .removeWhere((key, value) => key == furnitureList[index].furnitureId);
    }
    CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));

  }
  updateUserData(context,fName, lName, address, phone, {email,password,newPassword=""}) async {
    emit(UpdateLoadingState());
    int flag = 0;
    var temp = cacheModel!.usersCachedModel.where(
            (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);
    if(newPassword!=""){
      flag=2;
      AuthCredential credential = EmailAuthProvider.credential(
          email: temp.first.cachedUser.email, password: password);
      await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential( credential).then((value)async {
        await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
        password=newPassword;
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

  addToCart(String furnitureId, String selectedColor, int cartQuantity) async {
    print("Co;orr " + selectedColor);
    int index = furnitureList
        .indexWhere((element) => element.furnitureId == furnitureId);
    //SharedModel chosenFurnitureColor = furnitureList[index].shared.where((element) => element.color == selectedColor).first;
    int selectedIndex = furnitureList[index]
        .shared
        .indexWhere((element) => element.color == selectedColor);
    print("Selected Index = " + selectedIndex.toString());
    // chosenFurnitureColor.quantityCart = cartQuantity.toString();
    furnitureList[index].shared[selectedIndex].quantityCart =
        cartQuantity.toString();
    emit(AddedToCartSuccessfully());
    // var cachedtemp = cacheModel!.cachedModel.where(
    //     (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);
    // CachedUserModel cachedModel;
    // cachedModel = cachedtemp.first;
    print("Before");
    print(cache.cartMap);
    if (!cache.cartMap.keys.contains(furnitureId)) {
      cache.cartMap[furnitureId] = furnitureList[index].shared;
    } else {
      cache.cartMap[furnitureId][selectedIndex].quantityCart =
          cartQuantity.toString();
    }
    CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));
    print("After");
    print(cache.cartMap);
  }


  checkAvailableFurnitureQuantity(context) async {
    bool flag = false;
    Map<String, List<int>> availableQuantity = {};
    String categoryName = "";
    unavailableQuantityFurniture = [];

    for(String key in cache.cartMap.keys) {
      categoryName = furnitureList
          .where((element) => element.furnitureId == key)
          .first
          .category;

      await FirebaseFirestore.instance
          .collection('category')
          .doc(categoryName)
          .collection(categoryName)
          .doc(key)
          .get()
          .then((value) {
            availableQuantity[key] = [];
            for (int i = 0; i < value.data()!["shared"].length; i++) {
              availableQuantity[key]!.add(int.parse(value.data()!["shared"][i]["quantity"]));
            }
      }).catchError((error) {
        print("Error: " + error.toString());
      });

      for (int j = 0; j < cache.cartMap[key].length; j++) {
        if (int.parse(cache.cartMap[key][j].quantityCart) > availableQuantity[key]![j]) {
          flag = true;
          FurnitureModel furniture = furnitureList.where((element) => element.furnitureId == key).first;
          String itemString = availableQuantity[key]![j] == 1 ? "item" : "items";
          String availableQuantityString = availableQuantity[key]![j] == 0 ? " is out of stock." : " has only " + availableQuantity[key]![j].toString() + " ${itemString} left.";
          unavailableQuantityFurniture.add(furniture.shared[j].colorName + " " + furniture.name + availableQuantityString);
          // break;
        }
      }
      // if(flag) {
      //   break;
      // }
    }

    if(!flag) {
      bool isCacheChanged = false;

      cache.cartMap.forEach((key, value) async {
        int index =
        furnitureList.indexWhere((element) => element.furnitureId == key);

        bool isSharedModelChanged = false;

        for (int j = 0; j < value.length; j++) {
          if(int.parse(value[j].quantityCart) > 0) {
            isSharedModelChanged = true;
            isCacheChanged = true;
            furnitureList[index].shared[j].quantity =
                (availableQuantity[key]![j] - int.parse(value[j].quantityCart))
                    .toString();
            cache.cartMap[key][j].quantityCart = "0";
            furnitureList[index].shared[j].quantityCart = "0";
          }
        }

        if(isSharedModelChanged) {
          await FirebaseFirestore.instance
              .collection('category')
              .doc(categoryName)
              .collection(categoryName)
              .doc(key)
              .update({"shared": furnitureList[index].toMap()["shared"]})
              .then((value) => print("Added to cart successfully !")).catchError((error) => print("Error: " + error.toString()));
        }

      });

      if(isCacheChanged) {
        cache.cartMap.clear();
        emit(CheckoutSuccessfully());
      }

    } else {
      emit(ErrorInCheckout());
    }


  }


  createCache() async {
    var temp = await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    cacheModel = CacheModel(usersCachedModel: [
      CachedUserModel(
          uid: FirebaseAuth.instance.currentUser!.uid,
          cachedFavoriteIds: [],
          cachedUser: UserModel.fromJson(temp.data()!),
          cartMap: {}, cacheRecentlySearchedNames: [])
    ]);
    CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));
  }

  getCache() async {
    var temp = await CacheHelper.getData("user") ?? "";
    if (temp != "") {
      Map cachedMap = jsonDecode(temp);
      print(cachedMap);
      cacheModel = CacheModel.fromJson(cachedMap);
      var isUserCached = cacheModel!.usersCachedModel.where(
          (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);
      // CachedUserModel cache;
      if (isUserCached.isEmpty) {
        var temp = await FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        print(temp.data()!["fName"]);
        cacheModel!.usersCachedModel.add(CachedUserModel(
            uid: FirebaseAuth.instance.currentUser!.uid,
            cachedFavoriteIds: [],
            cachedUser: UserModel.fromJson(temp.data()!),
            cartMap: {}, cacheRecentlySearchedNames: []));
        print(cacheModel!.usersCachedModel.last.cachedUser.fName);
        // var cachedModel=cacheModel!.cachedModel.where((element) => element.uid==FirebaseAuth.instance.currentUser!.uid).first;
        // cachedModel.cachedFavoriteIds.remove(furnitureList[index].furnitureId);
        // print(jsonEncode(BlocProvider.of<HomeCubit>(context).cacheModel!.toMap()));
        CacheHelper.setData(
            key: 'user', value: jsonEncode(cacheModel!.toMap()));
        // return "";
      } else {
        return isUserCached.first;
      }
    } else {
      await createCache();
    }



    return cacheModel!.usersCachedModel.where(
            (element) => element.uid == FirebaseAuth.instance.currentUser!.uid).first;

  
    // return "";


  }

  addOrRemoveFromFavorite(index) async {
    furnitureList[index].isFavorite = !furnitureList[index].isFavorite;
    emit(SuccessOffersState());
    if (furnitureList[index].isFavorite == true) {
      // // if(cacheModel==null){
      // //  createCache();
      // // }
      // var cachedtemp = cacheModel!.usersCachedModel.where(
      //     (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);
      // CachedUserModel cachedModel;
      // cachedModel = cachedtemp.first;
      // print(cachedModel.cachedUser.fName);
      cache.cachedFavoriteIds.add(furnitureList[index].furnitureId);
      CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));
    } else {
      // var cachedModel = cacheModel!.usersCachedModel
      //     .where((element) =>
      //         element.uid == FirebaseAuth.instance.currentUser!.uid)
      //     .first;
      cache.cachedFavoriteIds.remove(furnitureList[index].furnitureId);
      // print(jsonEncode(BlocProvider.of<HomeCubit>(context).cacheModel!.toMap()));
      CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));
    }
  }
  addToRecentlySearchedName (String searchName){
    if(cache.cacheRecentlySearchedNames.length < 5) {
      if(!cache.cacheRecentlySearchedNames.contains(searchName)) {
        cache.cacheRecentlySearchedNames.add(searchName);
        print(cache.cacheRecentlySearchedNames);
        print("hahaha");

        CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));
      }
    }else {
      if(!cache.cacheRecentlySearchedNames.contains(searchName)) {
        cache.cacheRecentlySearchedNames.removeAt(0);
        cache.cacheRecentlySearchedNames.add(searchName);
        print(cache.cacheRecentlySearchedNames);
        print("hahaha");
        CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));
      }
    }
  }
}

class CacheModel {
  List<CachedUserModel> usersCachedModel = [];

  CacheModel({required this.usersCachedModel});

  CacheModel.fromJson(json) {
    json["cachedModel"].forEach((element) {
      usersCachedModel.add(CachedUserModel.fromJson(element));
    });
  }

  Map toMap() {
    return {"cachedModel": usersCachedModel.map((e) => e.toMap()).toList()};
  }
}

class CachedUserModel {
  late String uid;
  List<String> cachedFavoriteIds = [];
  Map<String, dynamic> cartMap = {};
  List<String> cacheRecentlySearchedNames = [];

  // List<CartModel> cartModels = [];
  late UserModel cachedUser;

  // late CartModel cachedCart;
  CachedUserModel(
      {required this.uid,
      required this.cachedFavoriteIds,
      required this.cachedUser,
      required this.cartMap,
      required this.cacheRecentlySearchedNames
      });

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

    if (json["cacheRecentlySearchedNames"] != null) {
      json["cacheRecentlySearchedNames"].forEach((element) {
        cacheRecentlySearchedNames.add(element);
      });
    } else {
      cacheRecentlySearchedNames = [];
    }

    cachedUser = UserModel.fromJson(json["userData"]);

    // cartMap = json["cartData"];

if(json["cartData"]!=null)

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
      "cartData": tempCartMap,
      "cacheRecentlySearchedNames":cacheRecentlySearchedNames
    };
  }
}
