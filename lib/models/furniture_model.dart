import 'dart:ffi';

import 'package:ar_furniture_app/models/shared_model.dart';

class FurnitureModel {
  String? description;
  late String furnitureId;
  late String name;
  late String model;
  List<SharedModel> shared=[];
  bool isFavorite=false;

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
    json["shared"].forEach((value){
      print(value);
     shared.add(SharedModel.fromJson(value));
    });
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
