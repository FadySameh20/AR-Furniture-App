
class CategoryItem{
  late String name;
  late String image;


  CategoryItem({required this.name,required this.image});

  CategoryItem.fromJson(Map json){
    name=json["name"];
    image=json["image"];
  }


  Map toMap(){
    return {"name":name,"image":image};
  }

}