class CategoryModel {
  late String count;
  late String payment;

  CategoryModel({
    required this.count,
    required this.payment,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    count = json["count"];
    payment = json["payment"];
  }
  Map<String, dynamic> toMap() {
    return {
      "count": count,
      "payment": payment,
    };
  }
}
