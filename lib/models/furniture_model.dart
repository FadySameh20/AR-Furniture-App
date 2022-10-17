import 'dart:ffi';

import 'package:ar_furniture_app/models/shared_model.dart';

class FurnitureModel {
  late String furnitureId;
  String? description;
  late String name;
  late String model;
  late List<SharedModel> shared;

  FurnitureModel({
    required this.furnitureId,
    this.description,
    required this.name,
    required this.model,
    required this.shared,
  });

  FurnitureModel.fromJson(Map<String, dynamic> json) {

    description = json["description"];
    name = json["name"];
    model = json["model"];
    for (int i = 0; i < shared.length; i++){
      shared[i] =SharedModel.fromJson(json["shared"][i]);

    }

  }
  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "name": name,
      "model": model,
      "shared":shared,

    };
  }
}
