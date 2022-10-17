import 'dart:ffi';

import 'package:ar_furniture_app/models/shared_model.dart';

class FurnitureModel {
  String? description;
  late String furnitureId;
  late String name;
  late String model;
  late List<SharedModel> shared;

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
    for (int i = 0; i < shared.length; i++) {
      shared[i] = SharedModel.fromJson(json["shared"][i]);
    }
  }
  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "furnitureId": furnitureId,
      "name": name,
      "model": model,
      "shared": shared,
    };
  }
}
