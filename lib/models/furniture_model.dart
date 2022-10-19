import 'dart:ffi';

import 'package:ar_furniture_app/models/shared_model.dart';

class FurnitureModel {
  String? description;
  late String furnitureId;
  late String name;
  late String model;
  late String category;
  List<SharedModel> shared = [];

  FurnitureModel({
    this.description,
    required this.furnitureId,
    required this.name,
    required this.model,
    required this.shared,
  });

  FurnitureModel.fromJson(Map<String, dynamic> json) {
    description = json["description"];
    furnitureId = json["furnitureId"];
    name = json["name"];
    model = json["model"];
    category=json["category"];
    print("before");
    print(shared);
    for (int i = 0; i < json["shared"].length; i++) {
      shared.add(SharedModel.fromJson(json["shared"][i]));
    }
    print("after");
    print(shared);
  }
  Map<String, dynamic> toMap() {
    return {
      "category":category,
      "description": description,
      "furnitureId": furnitureId,
      "name": name,
      "model": model,
      "shared": shared,
    };
  }
}
