import 'dart:convert';

import 'dart:ui';

import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/category_model.dart';
import 'package:ar_furniture_app/models/furniture_model.dart';
import 'package:ar_furniture_app/models/offers_model.dart';
import 'package:ar_furniture_app/models/shared_model.dart';
import 'package:ar_furniture_app/models/statistics_model.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:ar_furniture_app/shared/widgets/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/name_model.dart';
import '../models/order_model.dart';
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
  List<String> changedDiscountList = [];
  List<FurnitureModel> recommendedFurniture = [];
  Map<String, dynamic> orderMap = {};
  Map<String,dynamic>statisticsMap={};
  Map<String,dynamic>statisticsSameMonthMap={};
  double income=0;
  int orderNumberSameMonth=0;
  double incomeSameMonth=0;
  List<OrderModel> orders = [];
  var cache;
  DocumentSnapshot? _lastDocumentSearch;
  String lastSearchbarName = "";
  bool moreFurnitureAvailable = true;
  Map<String, dynamic> lastDocMap = {};
  var isDark;

  changeTheme()async{
    isDark=!isDark;
    await CacheHelper.setData(key: "darkMode", value: isDark);
    // print(CacheHelper.getData("darkMode"));
    print("isDark: ");
    print(isDark);
    emit(ThemeModeState());
  }
  getAllData() async {
    //// await createCache();
    isDark=CacheHelper.getData("darkMode")??false;
    await getCategoryNames();
   // await putStatistics();
    await getOffers();
    if (FirebaseAuth.instance.currentUser != null) {
      cache = await getCache();
    } else {
      cache = "";
    }
    print(FirebaseAuth.instance.currentUser!.uid);
    // print(cacheModel.cachedModel.where((element) => ))
    for (int i = 0; i < categories.length; i++) {
      print(categories[i].name);

      await getFurniture(categories[i].name, limit: 3);

    }
    await getFavorites();
    HomePage.recommendedItems=furnitureList.length;
  }

  setCache() async {
    cache = await getCache();
    orders = [];
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
    List favoritesId;
    if (cache == "") {
      favoritesId = [];
    } else {
      favoritesId = cache.cachedFavoriteIds;
    }
    print("ANA GET SEARCH DATA   $searchbarName");
    int sizeFurniture = furnitureList.length;
    lastSearchbarName = searchbarName;
    moreFurnitureAvailable = true;
    int flag = 0;
    await FirebaseFirestore.instance
        .collectionGroup("furniture")
        .where('name',
        isGreaterThanOrEqualTo: searchbarName,
        isLessThanOrEqualTo: '$searchbarName\uf8ff')
        .orderBy('name')
        .limit(6)
        .get()
        .then((snapshot) {
      if(snapshot.docs.length < 6) {
        moreFurnitureAvailable = false;
      }
      if (snapshot.docs.length != 0) {
        _lastDocumentSearch = snapshot.docs.last;
        print("searchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
        snapshot.docs.forEach((snap) {
          print(snap.data());
          FurnitureModel myFurniture = FurnitureModel.fromJson(snap.data());
          flag = 0;
          furnitureList.forEach((element) {
            if (element.furnitureId == myFurniture.furnitureId) {
              flag = 1;
            }
          });
          if (flag == 0) {
            furnitureList.add(myFurniture);
            if (favoritesId.contains(myFurniture.furnitureId)) {
              furnitureList.last.isFavorite = true;
            }
          }
        });
        print("===========================================");
      }
    }).catchError((error) => print("Error: " + error.toString()));
    print("ANA 5LAST GET SEARCH DATA   $searchbarName");
    if (sizeFurniture == furnitureList.length) {
      moreFurnitureAvailable = false;
    }
  }

  getMoreSearchData (String searchbarName) async {
    print("ANA GET MORE DATAAAAAAA  $searchbarName");
    print(moreFurnitureAvailable);
    if (moreFurnitureAvailable == false) {
      return;
    }
    List favoritesId;
    if (cache == "") {
      favoritesId = [];
    } else {
      favoritesId = cache.cachedFavoriteIds;
    }
    int flag = 0;
    int sizeFurniture = furnitureList.length;
    await FirebaseFirestore.instance
        .collectionGroup("furniture")
        .where('name',
        isGreaterThanOrEqualTo: searchbarName,
        isLessThanOrEqualTo: '$searchbarName\uf8ff')
        .orderBy('name')
        .startAfter([_lastDocumentSearch?.data()])
        .limit(6)
        .get()
        .then((snapshot) {
      if(snapshot.docs.length < 6) {
        moreFurnitureAvailable = false;
      }
      if (snapshot.docs.length != 0) {
        _lastDocumentSearch = snapshot.docs.last;
        print("searchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
        snapshot.docs.forEach((snap) {
          print(snap.data());
          FurnitureModel myFurniture = FurnitureModel.fromJson(snap.data());
          flag = 0;
          furnitureList.forEach((element) {
            if (element.furnitureId == myFurniture.furnitureId) {
              flag = 1;
            }
          });
          if (flag == 0) {
            furnitureList.add(myFurniture);
            if (favoritesId.contains(myFurniture.furnitureId)) {
              furnitureList.last.isFavorite = true;
            }
          }
        });
        print("===========================================");
      }
    }).catchError((error) => print("Error: " + error.toString()));
    print("ANA 5LAST GET MORE DATAAAAAAA  $searchbarName");
    if (sizeFurniture == furnitureList.length) {
      moreFurnitureAvailable = false;
    }
  }

  String capitalizeFirstLettersInView(String text) {
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = '${words[i][0].toUpperCase()}${words[i].substring(1)}';
      }
    }
    return words.join(' ');
  }

  getOffers() async {
    await FirebaseFirestore.instance.collection('offer').get().then((value) {
      print("aaaaaaaaaaaaaaaaaaa");
      print(value.docs.length);
      print(value.docs);
      for (var element in value.docs) {
        print("sss");
        print(element["salesId"]);
        offers.add(Offers.fromJson(element.data()));
      }
      print(offers.length);
      emit(SuccessOffersState());
    }).catchError((error) {
      emit(ErrorOffersState());
    });
    print(offers.length);
  }

  getFurniture(String categoryName, {limit = 0}) async {
    if(!returnedCategory.contains(categoryName)) {
      returnedCategory.add(categoryName);
    }

    List favoritesId;
    if (cache == "") {
      favoritesId = [];
    } else {
      favoritesId = cache.cachedFavoriteIds;
    }
    int flag = 0;
    print(favoritesId);
    if (limit == 0) {
      await FirebaseFirestore.instance
          .collection('category')
          .doc(categoryName)
          .collection('furniture')
          .get()
          .then((value) {
        for (var element in value.docs) {
          FurnitureModel myFurniture = FurnitureModel.fromJson(element.data());
          flag = 0;
          furnitureList.forEach((element) {
            if (element.furnitureId == myFurniture.furnitureId) {
              flag = 1;
            }
          });
          if (flag == 0) {
            furnitureList.add(myFurniture);
            if (favoritesId.contains(myFurniture.furnitureId)) {
              furnitureList.last.isFavorite = true;
            }
          }
        }
      });
    } else {

        if(lastDocMap.keys.contains(categoryName)) {
          await FirebaseFirestore.instance
              .collection('category')
              .doc(categoryName)
              .collection("furniture")
              .orderBy('furnitureId')
              .startAfter([lastDocMap[categoryName].get('furnitureId')])
              .limit(limit)
              .get()
              .then((snapshot) {
                print("Test");
                print(snapshot.docs.length);
                if(snapshot.docs.length > 0) {
                  lastDocMap[categoryName] = snapshot.docs.last;
                }

                snapshot.docs.forEach((snap) {
                  print("Snap" + lastDocMap[categoryName].get('furnitureId'));
                  FurnitureModel myFurniture = FurnitureModel.fromJson(snap.data());
                  flag = 0;
                  furnitureList.forEach((element) {
                    if (element.furnitureId == myFurniture.furnitureId) {
                      flag = 1;
                    }
                  });
                  if (flag == 0) {
                    furnitureList.add(myFurniture);
                    if (favoritesId.contains(myFurniture.furnitureId)) {
                      furnitureList.last.isFavorite = true;
                    }
                  }
            });

          }).catchError((error) => print("Error: " + error.toString()));

        } else {
          print(categoryName);
          await FirebaseFirestore.instance
              .collection('category')
              .doc(categoryName)
              .collection("furniture")
              //.orderBy('furnitureId')
              .limit(limit)
              .get()
              .then((snapshot) {
                print("Test");
                print(snapshot.docs.length);
                if(snapshot.docs.length > 0) {
                  lastDocMap[categoryName] = snapshot.docs.last;
                }
                print(lastDocMap);

                snapshot.docs.forEach((snap) {
                print("Snap " + lastDocMap[categoryName].get('furnitureId'));
                print(snap.data());
                FurnitureModel myFurniture = FurnitureModel.fromJson(snap.data());
                flag = 0;
                furnitureList.forEach((element) {
                  if (element.furnitureId == myFurniture.furnitureId) {
                    flag = 1;
                  }
                });
                if (flag == 0) {
                  furnitureList.add(myFurniture);
                  if (favoritesId.contains(myFurniture.furnitureId)) {
                    furnitureList.last.isFavorite = true;
                  }
                }
            });

          }).catchError((error) => print("Error: " + error.toString()));


        }
      }

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

  List<Color?> getAvailableColorsOfFurniture(FurnitureModel selectedFurniture, [bool flag = false]) {
    if(!flag) {
      availableColors.clear();
      for (int i = 0; i < selectedFurniture.shared.length; i++) {
        availableColors.add(getColorFromHex(selectedFurniture.shared[i].color));
      }
      return availableColors;
    } else {
      List<Color?> tempColors = [];
      for (int i = 0; i < selectedFurniture.shared.length; i++) {
        tempColors.add(getColorFromHex(selectedFurniture.shared[i].color));
      }
      return tempColors;
    }

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
    }
  }

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

  updateUserData(context, fName, lName, address, phone, img,
      {email, password, newPassword = ""}) async {
    emit(UpdateLoadingState());
    int flag = 0;
    var temp = cacheModel!.usersCachedModel.where(
        (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);
    if (newPassword != "") {
      flag = 2;
      AuthCredential credential = EmailAuthProvider.credential(
          email: temp.first.cachedUser.email, password: password);
      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(credential)
          .then((value) async {
        await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
        password = newPassword;
        emit(UpdatePasswordSuccessState());
      }).catchError((error) {
        emit(UpdatePasswordErrorState("Incorrect email or password"));
      });
    }
    print(temp.first.cachedUser.email);
    print(email);
    if (temp.first.cachedUser.email != email) {
      flag = 1;
      AuthCredential credential = EmailAuthProvider.credential(
          email: temp.first.cachedUser.email, password: password);
      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(credential)
          .then((value) async {
        await FirebaseAuth.instance.currentUser?.updateEmail(email);
        temp.first.cachedUser.email = email;
        emit(UpdateEmailSuccessState());
      }).catchError((error) {
        emit(UpdateEmailErrorState("Incorrect email or password"));
      });
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
    if (img != null) {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      if (temp.first.cachedUser.img != "") {
        await FirebaseStorage.instance
            .refFromURL(temp.first.cachedUser.img.toString())
            .delete();
      }
      final ref = FirebaseStorage.instance
          .ref()
          .child("users/$userId.${img.path.split(".").last}");
      await ref.putFile(img);
      final url = await ref.getDownloadURL();
      temp.first.cachedUser.img = url;
      flag = 1;
    }

    if (flag == 1) {
      CacheHelper.setData(key: "user", value: jsonEncode(cacheModel!.toMap()));
      await FirebaseFirestore.instance
          .collection("user")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(temp.first.cachedUser.toMap())
          .then((value) {
        emit(UpdateUserDataSuccessData());
      }).catchError((error) {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Nothing to update")));
    }
  }

  addToCart(String furnitureId, String selectedColor, int cartQuantity) async {
    print("Co;orr " + selectedColor);
    int index = furnitureList
        .indexWhere((element) => element.furnitureId == furnitureId);
    //SharedModel chosenFurnitureColor = furnitureList[index].shared.where((element) => element.color == selectedColor).first;
    int selectedIndex = furnitureList[index]
        .shared
        .indexWhere((element) => element.color.toLowerCase() == selectedColor.toLowerCase());
    print("Selected Index = " + selectedIndex.toString());
    // chosenFurnitureColor.quantityCart = cartQuantity.toString();
    furnitureList[index].shared[selectedIndex].quantityCart =
        cartQuantity.toString();
    print("quantityyyyyyyycart"+ cartQuantity.toString());

    // var cachedtemp = cacheModel!.cachedModel.where(
    //     (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);
    // CachedUserModel cachedModel;
    // cachedModel = cachedtemp.first;
    print("Before");
    print(cache.cartMap);
    if (!cache.cartMap.keys.contains(furnitureId)) {
      // Map<String,dynamic> tempMap1=jsonDecode(jsonEncode(furnitureList[index].shared[j].toMap()));
      // Map<String,dynamic> tempMap2=jsonDecode(jsonEncode(furnitureList[index].shared[j].toMap()));
      // furnitureList[index].shared[j]=SharedModel.fromJson(tempMap1);
      // cache.cartMap[key][j]=SharedModel.fromJson(tempMap2);
      cache.cartMap[furnitureId]=[];
      print("test");
      for(int i=0;i<furnitureList[index].shared.length;i++) {
        cache.cartMap[furnitureId].add(SharedModel.fromJson(furnitureList[index].shared[i].toMap()));

      }
      cache.cartMap[furnitureId][selectedIndex].quantityCart=cartQuantity.toString();
      print("quantityyyyyyyycarrrrrt"+ cartQuantity.toString());
      // cache.cartMap[furnitureId].add(SharedModel.fromJson(furnitureList[index].shared[selectedIndex].toMap()));
      // cache.cartMap[furnitureId][selectedIndex].quantityCart=cartQuantity.toString();
      print(cache.cartMap[furnitureId]);
      print(cache.cartMap);
      emit(AddedToCartSuccessfully());
    } else {
      // cache.cartMap[furnitureId].add(SharedModel.fromJson(furnitureList[index].shared[selectedIndex].toMap()));
      cache.cartMap[furnitureId][selectedIndex].quantityCart =
          cartQuantity.toString();

      cache.cartMap[furnitureId][selectedIndex].quantity =
          furnitureList[index].shared[selectedIndex].quantity;
    }
    print("Quantity Value in FurnitureList = " +
        furnitureList[index].shared[selectedIndex].quantity);
    print("Quantity Value in Cart = " +
        cache.cartMap[furnitureId][selectedIndex].quantity);
    CacheHelper.setData(key: 'user', value: jsonEncode(cacheModel!.toMap()));
    print("After");
    print(cache.cartMap);
  }

  checkAvailableFurnitureQuantity(
      String appartmentNumber,
      String area,
      String buildingNumber,
      String floorNumber,
      String mobileNumber,
      String streetName) async {
    emit(LoadingMakeOrder());
    bool flag = false;
    bool discountFlag = false;
    Map<String, List<int>> availableQuantity = {};
    Map<String, List<double>> currentDiscounts = {};
    String categoryName = "";
    unavailableQuantityFurniture = [];
    
    for (String key in cache.cartMap.keys) {
      categoryName = furnitureList
          .where((element) => element.furnitureId == key)
          .first
          .category;

      await FirebaseFirestore.instance
          .collection('category')
          .doc(categoryName)
          .collection("furniture")
          .doc(key)
          .get()
          .then((value) {
            currentDiscounts[key] = [];
        availableQuantity[key] = [];
        for (int i = 0; i < value.data()!["shared"].length; i++) {
          availableQuantity[key]!
              .add(int.parse(value.data()!["shared"][i]["quantity"]));
          currentDiscounts[key]!.add(double.parse(value.data()!["shared"][i]["discount"]));
        }
        print('availablequantity list');
        print(availableQuantity);
      }).catchError((error) {
        print("Error: " + error.toString());
      });

      for (int j = 0; j < cache.cartMap[key].length; j++) {
        print(availableQuantity[key]![j]);
        
        if (int.parse(cache.cartMap[key][j].quantityCart) >
            availableQuantity[key]![j]) {
          flag = true;
          FurnitureModel furniture = furnitureList
              .where((element) => element.furnitureId == key)
              .first;
          String itemString =
              availableQuantity[key]![j] == 1 ? "item" : "items";
          String availableQuantityString = availableQuantity[key]![j] == 0
              ? " is out of stock."
              : " has only " +
                  availableQuantity[key]![j].toString() +
                  " ${itemString} left.";
          unavailableQuantityFurniture.add(furniture.shared[j].colorName +
              " " +
              furniture.name +
              availableQuantityString);
          // break;
        }
      }
      // if(flag) {
      //   break;
      // }
    }

    if (!flag) {
      bool isCacheChanged = false;
      print("Cached map to order map");
      print(cache.cartMap);
      print("after printing cache map");

      print("Cart Check");
      print(cache.cartMap);
      List<SharedModel> orderedSharedList = [];
      orderMap.clear();
      income=0;

      cache.cartMap.forEach((key, value) {
        orderedSharedList = [];
        value.forEach((element) {
          if (int.parse(element.quantityCart) > 0) {
            element.quantity =
                (int.parse(element.quantity) - int.parse(element.quantityCart))
                    .toString();
            String tempQuantityCart = element.quantityCart;
            orderedSharedList.add(SharedModel.fromJson(element.toMap()));
            orderedSharedList.last.quantityCart = tempQuantityCart;
            String categoryNameStatistics=furnitureList.where((element) => element.furnitureId==key).first.category;
            String paymentinitial=(double.parse(element.price) -( (double.parse(element.discount)/100)*double.parse(element.price))).toStringAsFixed(2);
            CategoryModel tempCategoryModel;
            if(statisticsMap.containsKey(categoryNameStatistics)){
              tempCategoryModel = CategoryModel(
                count: (
                    (int.parse(statisticsMap[categoryNameStatistics].count)+int.parse(tempQuantityCart)).toString()), payment:(double.parse(statisticsMap[categoryNameStatistics].payment)+ (double.parse(paymentinitial)*double.parse(tempQuantityCart))).toString());
            statisticsMap[categoryNameStatistics]=tempCategoryModel;}
            else{tempCategoryModel = CategoryModel(
                count: (
                    int.parse(tempQuantityCart).toString()), payment: (double.parse(paymentinitial)*double.parse(tempQuantityCart)).toString());
              statisticsMap[categoryNameStatistics]=tempCategoryModel;}
            income=income+(double.parse(paymentinitial)*double.parse(tempQuantityCart));

            print ("categoryname"+categoryNameStatistics);
            print ("payment"+statisticsMap[categoryNameStatistics].payment);
            print("income"+income.toStringAsFixed(2));



            //categoryMap[categoryName]=
            print("Orders List");
            print(orderedSharedList);
          }
        });
        String name=key+"|"+furnitureList.where((element) => element.furnitureId==key).first.name;
        orderMap[name] = orderedSharedList;
        print(orderMap);
      });

      print("Cart map");
      print(cache.cartMap);
      print("Order Map");
      print(orderMap);
      // await createOrder(appartmentNumber, area, buildingNumber, floorNumber, mobileNumber, streetName);


      for (String key in cache.cartMap.keys) {
        for (int j = 0; j < cache.cartMap[key].length; j++) {
          print("Discount in cache " + cache.cartMap[key][j].discount.toString());
          print("Discount in Firestore " + currentDiscounts[key]![j].toString());
          if (double.parse(cache.cartMap[key][j].discount) !=
              currentDiscounts[key]![j]) {
            discountFlag = true;
            FurnitureModel furniture = furnitureList
                .where((element) => element.furnitureId == key)
                .first;
            changedDiscountList.add("Discount of " + furniture.name + " has changed !");
            cache.cartMap[key][j].discount = currentDiscounts[key]![j].toString();
          }
        }
      }

      if(!discountFlag) {
        cache.cartMap.forEach((key, value) async {
          int index =
          furnitureList.indexWhere((element) => element.furnitureId == key);

          bool isSharedModelChanged = false;

          for (int j = 0; j < value.length; j++) {
            if (int.parse(value[j].quantityCart) > 0) {
              isSharedModelChanged = true;
              isCacheChanged = true;
              furnitureList[index].shared[j].quantity =
                  (availableQuantity[key]![j] - int.parse(value[j].quantityCart))
                      .toString();
              String tempDiscount = cache.cartMap[key][j].discount;
              // Map<String,dynamic> tempMap1=jsonDecode(jsonEncode(furnitureList[index].shared[j].toMap()));
              // Map<String,dynamic> tempMap2=jsonDecode(jsonEncode(furnitureList[index].shared[j].toMap()));
              // furnitureList[index].shared[j]=SharedModel.fromJson(tempMap1);
              // cache.cartMap[key][j]=SharedModel.fromJson(tempMap2);
              furnitureList[index].shared[j].discount = currentDiscounts[key]![j].toString();
              cache.cartMap[key][j].discount = tempDiscount;
              cache.cartMap[key][j].quantity =
                  (availableQuantity[key]![j] - int.parse(value[j].quantityCart))
                      .toString();
              print("Order quantityCart before");
              String tempKey = key+"|"+furnitureList.where((element) => element.furnitureId==key).first.name;
              print(orderMap[tempKey][0].quantityCart);
              print(cache.cartMap[key][j].quantityCart);
              cache.cartMap[key][j].quantityCart = "0";
              furnitureList[index].shared[j].quantityCart = "0";
              print("Cache quantity value");
              print(orderMap[tempKey][0].quantityCart);
              print(cache.cartMap[key][j].quantityCart);
            }
          }

          if (isSharedModelChanged) {
            await FirebaseFirestore.instance
                .collection('category')
                .doc(categoryName)
                .collection("furniture")
                .doc(key)
                .update({"shared": furnitureList[index].toMap()["shared"]})
                .then((value) => print("Placed order successfully !"))
                .catchError((error) => print("Error: " + error.toString()));
          }
        });

        if (isCacheChanged) {
          cache.cartMap.clear();
          print("Cart after clearing");
          print(cache.cartMap);
          CacheHelper.setData(
              key: 'user', value: jsonEncode(cacheModel!.toMap()));
          // emit(CheckoutSuccessfully());
        }
      }

      if(discountFlag) {
        print("Error in discount");
        emit(ErrorInDiscount());
      } else {
        print("Orderrrr made");
        await createOrder(appartmentNumber, area, buildingNumber, floorNumber, mobileNumber, streetName);
        await putStatistics();
        emit(OrderMadeSuccessfully());
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

    return cacheModel!.usersCachedModel
        .where(
            (element) => element.uid == FirebaseAuth.instance.currentUser!.uid)
        .first;

    // return "";
  }

  getFavorites() async {
    bool flag = false;

    for (var elem in cache.cachedFavoriteIds) {
      flag = false;
      for(int i = 0; i < furnitureList.length; i++) {
        if(furnitureList[i].furnitureId == elem) {
          flag = true;
          break;
        }
      }
      if (flag) {
        continue;
      } else {
        for (var i = 0; i < categories.length; i++) {
          await FirebaseFirestore.instance
              .collection('category')
              .doc(categories[i].name)
              .collection("furniture")
              .doc(elem)
              .get()
              .then((value) {
            if (value.data() != null) {
              FurnitureModel fur =
                  FurnitureModel.fromJson(value.data() as Map<String, dynamic>);
              fur.isFavorite = true;
              furnitureList.add(fur);
            }
          });
        }
      }
    }
    print("yyyyyyyyyyyyyyyy");

  }

  addOrRemoveFromFavorite(furnitureId) async {
    int index = furnitureList
        .indexWhere((element) => element.furnitureId == furnitureId);
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
    searchName = capitalizeFirstLettersInView(searchName);
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

  getOrders() async {
    orders = [];
    await FirebaseFirestore.instance
        .collection("order")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element);
        orders.add(OrderModel.fromJson(element.data()));
      });
    });
    print(orders);
    orders.sort((a,b){
      return b.time.compareTo(a.time);
    });
  }


  putStatistics()async{
    print("d5al statistics");
    orderNumberSameMonth=0;
     incomeSameMonth=0;
    statisticsSameMonthMap={};
    DateTime time=DateTime.now();
    List<dynamic> years=[] ;
    int yearFlag=1;
    await FirebaseFirestore.instance
        .collection("years")
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        print("years");
        print(element.data().values.toList()[0]);
        for(var year in element.data().values.toList()[0] ){
          years.add(year);
          print (years);
        }
        for(int i=0;i<years.length;i++ ){
          if(years[i]==time.year.toString()){
            yearFlag=0;
          }
        }
        if(yearFlag==1){
years.add(time.year.toString());

await FirebaseFirestore.instance
                .collection("years")
                .doc(element.id)
                .update({"yearsList":years})
                .then((value) {
              print("years updateddddddddddddddddd successfully");});
        }






      });
    });

    String docId =
    await FirebaseFirestore.instance.collection("statistics").doc().id;
    print("Document ID statistics: " + docId);
    await FirebaseFirestore.instance
        .collection("statistics")
        .where("year", isEqualTo: time.year.toString() ).where("month",isEqualTo:time.month.toString())
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print("same year same month");
        print(element);
        docId =element.id;
        StatisticsModel statisticsModel=StatisticsModel.fromJson(element.data());
        print("incomeeeeeeeeeeeeeee"+statisticsModel.income);
        Map<String,dynamic>statisticsSameMonthMap={};
       incomeSameMonth=double.parse(statisticsModel.income);
        orderNumberSameMonth=int.parse(statisticsModel.ordersNumber);
        statisticsSameMonthMap=statisticsModel.category;

      });
    });

    income=(incomeSameMonth+income);
    statisticsSameMonthMap.forEach((key, value) {
      if(statisticsMap.containsKey(key)){
        CategoryModel tempCategoryModel;
        tempCategoryModel = CategoryModel(
            count: (
                (int.parse(statisticsMap[key].count)+int.parse(statisticsSameMonthMap[key])).toString()), payment:(double.parse(statisticsMap[key].payment)+ (double.parse(statisticsSameMonthMap[key].payment))).toString());
        statisticsMap[key]=tempCategoryModel;}
    });

    StatisticsModel statisticsModel=StatisticsModel(
        income: income.toStringAsFixed(2),
        ordersNumber:(orderNumberSameMonth+1).toString(),
        year: time.year.toString(),
        month: time.month.toString(),
        category: statisticsMap,

    );
    print("After creating statisticsModel");
    print(statisticsModel.category);
    print(statisticsModel.income);
    print(statisticsModel.ordersNumber);
    print("After printing category");
    if(orderNumberSameMonth==0){
    await FirebaseFirestore.instance
        .collection("statistics")
        .doc(docId)
        .set(statisticsModel.toMap())
        .then((value) {
      print("statistics successfully");

    }).catchError((error) {
      print('errorStatistics: ' + error.toString());
    });}
    else{
      await FirebaseFirestore.instance
          .collection("statistics")
          .doc(docId)
          .update(statisticsModel.toMap())
          .then((value) {
        print("statistics updateddddddddddddddddd successfully");

      }).catchError((error) {
        print('errorStatistics update: ' + error.toString());
      });}
    }






createOrder(String appartmentNumber, String area, String buildingNumber,
      String floorNumber, String mobileNumber, String streetName) async {
    String docId =
        await FirebaseFirestore.instance.collection("order").doc().id;
    print("Document ID: " + docId);
    String customerName = cache.cachedUser.fName + " " + cache.cachedUser.lName;
    OrderModel orderModel = OrderModel(
        orderId: docId,
        uid: FirebaseAuth.instance.currentUser!.uid,
        userName: customerName,
        time: Timestamp.now(),
        appartmentNumber: appartmentNumber,
        area: area,
        buildingNumber: buildingNumber,
        floorNumber: floorNumber,
        mobileNumber: mobileNumber,
        streetName: streetName,
        order: orderMap);

    print("After creating OrderModel");
    print(orderModel.order);
    print("After printing orders");
    await FirebaseFirestore.instance
        .collection("order")
        .doc(docId)
        .set(orderModel.toMap())
        .then((value) {
      print("Order made successfully");

    }).catchError((error) {
      print('errorOrder: ' + error.toString());
    });
    print("ya rbbb");
    if (orders.isNotEmpty) {
     await FirebaseFirestore.instance.collection("order").where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).orderBy("time", descending: true).limit(1).get().then((value){
        value.docs.forEach((element) {
          print(element);
          orders.insert(0,OrderModel.fromJson(element.data()));
        });
      });
    }
  }

  getFurnitureRecommendation(
      FurnitureModel selectedFurniture, int selectedColorIndex) {
    recommendedFurniture = [];
    List<FurnitureModel> sortedFurniture = furnitureList
        .where((element) => element.category == selectedFurniture.category)
        .toList();
    sortedFurniture.sort((a, b) =>
        a.shared[selectedColorIndex].price.compareTo(b.shared[0].price));
    int index = sortedFurniture.indexWhere(
        (element) => element.furnitureId == selectedFurniture.furnitureId);
    print("Sorted Furniture");
    print(sortedFurniture);
    print(index);

    for (int i = 1; i < 4; i++) {
      if (index - i >= 0) {
        recommendedFurniture.add(sortedFurniture[index - i]);
      }

      if (recommendedFurniture.length == 4) {
        break;
      }

      if (index + i < sortedFurniture.length) {
        recommendedFurniture.add(sortedFurniture[index + i]);
      }

      if (recommendedFurniture.length == 4) {
        break;
      }
    }
    // print(recommendedFurniture[0].name);
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

    if (json["cartData"] != null)
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
      tempSharedList = [];
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
