import 'dart:ffi';

import 'package:ar_furniture_app/models/shared_model.dart';

class OrderModel {
  late String uid;
  late String appartmentNumber;
  late String area;
  late String buildingNumber;
  late String floorNumber;
  late String mobileNumber;
  late String streetName;
  Map<String,dynamic> order={};


  // List<SharedModel> shared = [];
  // bool isFavorite=false;
  // List<double> ratings = [];

  OrderModel({
    required this.uid,
    required this.appartmentNumber,
    required this.area,
    required this.buildingNumber,
    required this.floorNumber,
    required this.mobileNumber,
    required this.streetName,
    required this.order,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    appartmentNumber = json["appartmentNumber"];
    area = json["area"];
    buildingNumber = json["buildingNumber"];
    floorNumber = json["floorNumber"];
    mobileNumber = json["mobileNumber"];
    streetName = json["streetName"];

    json["order"].forEach((key, value) {
      List<SharedModel> shared = [];
      value.forEach((element) {
        SharedModel tempShared = SharedModel.fromJson(element);
        tempShared.quantityCart = element['quantityCart'];
        shared.add(tempShared);
      });
      order[key] = shared;
    });
  }

    Map<String, dynamic> toMap() {
      Map<String, dynamic> tempCartMap = {};
      List<Map<String, dynamic>> tempSharedList = [];
      order.forEach((key, value) {
        value.forEach((element) {
          Map<String, dynamic> tempSharedMap = element.toMap();
          tempSharedMap['quantityCart'] = element.quantityCart;
          tempSharedList.add(tempSharedMap);
        });
        tempCartMap[key] = tempSharedList;
      });
      return {
        "uid": uid,
        "appartmentNumber": appartmentNumber,
        "area": area,
        "buildingNumber": buildingNumber,
        "floorNumber": floorNumber,
        "mobileNumber": mobileNumber,
        "streetName": streetName,
        "order": tempCartMap
      };
    }
  }


