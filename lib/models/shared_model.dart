class SharedModel {
  late String color;
  late String image;
  late String price;
  late String quantity;


  SharedModel(
      {
        required this.color,
        required this.image,
        required this.price,
        required this.quantity,

      });

  SharedModel.fromJson(Map<String, dynamic> json) {
    color = json["color"];
    image = json["image"];
    price = json["price"];
    quantity = json["quantity"];

  }
  Map<String, dynamic> toMap() {
    return {
      "color": color,
      "image": image,
      "price": price,
      "quantity": quantity,
    };
  }
}
