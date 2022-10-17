class Offers{
  late String  discount;
  late List colors;
  late String img;
  late String salesId;


  Offers({required this.discount, required this.colors,required this.img,required this.salesId});

  Offers.fromJson(Map< String,dynamic> json){
    discount=json[" discount"];
    colors = json[" colors"];
    img = json["img"];
    salesId = json["salesId"];

  }

  Map toMap(){

    return {
      "discount":discount,
      "colors":colors,
      "img":img,
      "salesId":salesId
    };
  }






}