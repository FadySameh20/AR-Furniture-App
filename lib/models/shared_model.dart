class SharedModel {
  late String color;
  late String image;
  late String price;
  late String quantity;
  bool isAddedCart=false;
  String quantityCart='0';

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
    // isAddedCart = json["isAddedCart"];
    // quantityCart = json["quantityCart"];
  }
  Map<String, dynamic> toMap() {
    print("Inside Shared Model");
    // print(isAddedCart);
    print(quantityCart);
    return {
      "color": color,
      "image": image,
      "price": price,
      "quantity": quantity,
      // "isAddedCart": isAddedCart,
      // "quantityCart": quantityCart,
    };
  }
}
