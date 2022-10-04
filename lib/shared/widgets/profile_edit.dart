import 'package:flutter/material.dart';


class ProfileEdit extends StatefulWidget{
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  // bool isObscurePassword = true;

  get labelText => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1)
                              )
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2016/12/19/21/36/woman-1919143_1280.jpg'
                                )
                            )
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 4,
                                    color: Colors.white
                                ),
                                color: Color.fromRGBO(191, 122, 47, 1)
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextField('Edit Your First Name'),
                      SizedBox(height: 10),
                      buildTextField('Edit Your Last Name'),
                      SizedBox(height: 10),
                      buildTextField('Edit Your Email'),
                      SizedBox(height: 10),
                      buildTextField('Edit Your Password'),
                      SizedBox(height: 10),
                      buildTextField('Edit Your Address'),
                      SizedBox(height: 10),
                      buildTextField('Edit Your Phone Number'),
                    ]),


                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                        onPressed: (){},
                        child: Text("CANCEL", style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.black
                        )),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20) )
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text("SAVE",style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.white
                        )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(191, 122, 47, 1),
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                    )
                  ],
                )
              ],
            )
        ),
      ),
    );
  }
    Widget buildTextField(String LabelText){
    return TextField(
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(214, 189, 169,1),width: 2.0)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(157, 139, 124,1),width: 5.0)),
        labelText: LabelText,
        labelStyle: TextStyle(
          color: Color.fromRGBO(124, 58, 40,1),
          fontSize: 13,
        ),
        // hintText: "Edit Your Password"
      ),
      cursorColor:Color.fromRGBO(124, 58, 40,1) ,
    );
  }
}