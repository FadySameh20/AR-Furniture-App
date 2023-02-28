import 'dart:ffi';

import 'package:ar_furniture_app/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsModel {
  late String income;
  late String ordersNumber;
  late String year;
  late String month;
  Map<String, dynamic> category = {};

  StatisticsModel({
    required this.income,
    required this.ordersNumber,
    required this.year,
    required this.month,
    required this.category,
  });

  StatisticsModel.fromJson(Map<String, dynamic> json) {
    income = json["income"];
    ordersNumber = json["ordersNumber"];
    year = json["year"];
    month = json["month"];
    json["category"].forEach((key, value) {
      category[key] = CategoryModel.fromJson(value);
    });
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> tempCategoryMap = {};
    category.forEach((key, value) {
      tempCategoryMap[key] = value.toMap();
    });
    return {
      "income": income,
      "ordersNumber": ordersNumber,
      "year": year,
      "month": month,
      "category": tempCategoryMap
    };
  }
}
