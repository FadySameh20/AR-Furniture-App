import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/shared/widgets/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../models/user_model.dart';
import '../constants/constants.dart';
import 'cart_screen.dart';
import 'favorite_screen.dart';


class ProfileEdit extends StatefulWidget{
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  // bool isObscurePassword = true;
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var emailController = TextEditingController();
  var newPasswordController= TextEditingController();
  var oldPasswordController= TextEditingController();
  var addressController= TextEditingController();
  String initialCountry = 'EG';
  var number ;
  Validations validator = Validations();
  TextEditingController mobileNumberController = TextEditingController();
  var formKey=GlobalKey<FormState>();
  get labelText => null;
  List<Widget> NavbarPages = [ProfileEdit(),FavoriteScreen()];
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  getImage(int flag) async {
    XFile? image;
    imageFile = null;
    if (flag == 0) {
      image = await _picker.pickImage(source: ImageSource.gallery);
    } else {
      image = await _picker.pickImage(source: ImageSource.camera);
    }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var temp=BlocProvider.of<HomeCubit>(context).cacheModel!.usersCachedModel.where((element) => element.uid==FirebaseAuth.instance.currentUser!.uid);
    UserModel userModel=temp.first.cachedUser;
    fNameController.text= userModel.fName;
    lNameController.text = userModel.lName;
    emailController.text = userModel.email;
    newPasswordController.text ="";
    oldPasswordController.text="";
    addressController.text = userModel.address;
    // number.phoneNumber=userModel.phone;
    number=PhoneNumber(phoneNumber:userModel.phone,isoCode: 'EG');
    // number=phone
    mobileNumberController.text= userModel.phone;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(191, 122, 47, 1),
        // leading: FlutterLogo(),
        centerTitle: true,
        title: const Text('Edit Profile'),
      ),
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
                                color: kAppBackgroundColor,
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
                Form(
                  key: formKey,
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTextField('Edit Your First Name',fNameController,validator: (String? val) {
                          return validator.validateName(val!);
                        },),
                        SizedBox(height: 10),
                        buildTextField('Edit Your Last Name',lNameController,validator: (String? val) {
                          return validator.validateName(val!);
                        }),
                        SizedBox(height: 10),
                        buildTextField('Edit Your Email',emailController,validator: (String? val) {
                          return validator.validateEmail(val!);
                        },),
                        SizedBox(height: 10),
                        buildTextField('Enter Your current Password',oldPasswordController,isPassword: true),
                        SizedBox(height: 10),
                        buildTextField('Edit Your Password',newPasswordController,validator: (String? val) {
                          if((emailController.text.isEmpty||oldPasswordController.text.isEmpty)&&newPasswordController.text.isNotEmpty)
                          return validator.validatePassword(val!);
                          else{
                            return null;
                          }
                        },isPassword:true),
                        SizedBox(height: 10),
                        buildTextField('Edit Your Address',addressController,validator: (String? val) {
                          return validator.validateAddress(val!);
                        }),
                        SizedBox(height: 10),
                        InternationalPhoneNumberInput(
                          spaceBetweenSelectorAndTextField:
                          0,
                          onInputValidated: (value){},
                          onInputChanged:
                              (PhoneNumber number) {},
                          selectorConfig:
                          const SelectorConfig(
                            selectorType:
                            PhoneInputSelectorType
                                .BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode:
                          AutovalidateMode
                              .onUserInteraction,
                          selectorTextStyle:
                          const TextStyle(
                              color: Colors.black),
                          initialValue: number,
                          textFieldController:
                          mobileNumberController,
                          formatInput: false,
                          keyboardType:
                          const TextInputType
                              .numberWithOptions(
                              signed: true,
                              decimal: true),
                          inputBorder:
                          const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    20.0)),
                          ),
                        ),
                      ]),
                ),


                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    ElevatedButton(
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                            if (newPasswordController.text.isNotEmpty) {
                              BlocProvider.of<HomeCubit>(context).updateUserData(
                                  context,
                                  fNameController.text,
                                  lNameController.text,
                                  addressController.text,
                                  mobileNumberController.text,
                                  imageFile,
                                  email: emailController.text,
                                  password: oldPasswordController.text,
                                  newPassword: newPasswordController.text);
                            } else {
                              BlocProvider.of<HomeCubit>(context).updateUserData(
                                  context,
                                  fNameController.text,
                                  lNameController.text,
                                  addressController.text,
                                  mobileNumberController.text,
                                  imageFile,
                                  email: emailController.text,
                                  password: oldPasswordController.text);
                            }
                          }
                        },
                        child: Text("SAVE",style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.white
                        )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAppBackgroundColor,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            )
        ),
      ),
    );
  }
    Widget buildTextField(String labelText,controller,{validator=null,isPassword=false}){
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(

        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(214, 189, 169,1),width: 2.0)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(157, 139, 124,1),width: 5.0)),
        labelText: labelText,
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