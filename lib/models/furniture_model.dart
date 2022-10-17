import 'dart:ffi';

import 'package:ar_furniture_app/models/shared_model.dart';

class FurnitureModel {
  String? description;
  late String name;
  late String model;
  late List<SharedModel> shared;

  FurnitureModel({
    this.description,
    required this.name,
    required this.model,
    required this.shared,
  });

  FurnitureModel.fromJson(Map<String, dynamic> json) {
    description = json["description"];
    name = json["name"];
    model = json["model"];
    shared =json["shared"];
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
