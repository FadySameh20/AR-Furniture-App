class UserModel{
  late String fName;
  late String lName;
  late String address;
  late String phone;
  late String uid;
  late String email;
  String? img;

  UserModel({required this.fName,required this.lName,required this.phone,required this.address,required this.uid,required this.email,this.img});

  UserModel.fromJson(Map<String,dynamic> json){
    fName=json["fName"];
    lName=json["lName"];
    address=json["address"];
    phone=json["phone"];
    uid=json["uid"];
    email=json["email"];
    img=json["img"];
  }
  Map<String,dynamic> toMap(){
    return {"fName":fName,"lName":lName,"address":address,
      "phone":phone,"uid":uid,"email":email,"img":img};
  }
}