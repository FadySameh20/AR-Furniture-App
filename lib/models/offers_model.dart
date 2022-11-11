class Offers{
  late String  discount;
  late List colors=[];
  late String img;
  late String salesId;
  late String category;


  Offers({required this.discount, required this.colors,required this.img,required this.salesId, required this.category});

  Offers.fromJson(Map< String,dynamic> json){
    discount=json["discount"];
    json["colors"].forEach((element){
      colors.add(element);
    });
    img = json["img"];
    salesId = json["salesId"];
    category = json["category"];

  }

  Map toMap(){

    return {
      "discount":discount,
      "colors":colors,
      "img":img,
      "salesId":salesId,
      "category": category
    };
  }






}