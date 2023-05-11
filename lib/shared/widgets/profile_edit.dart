import 'dart:io';
import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/shared/widgets/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../models/user_model.dart';
import '../constants/constants.dart';
import 'favorite_screen.dart';

class ProfileEdit extends StatefulWidget {
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  // bool isObscurePassword = true;
  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var emailController = TextEditingController();
  var newPasswordController = TextEditingController();
  var oldPasswordController = TextEditingController();
  var addressController = TextEditingController();
  String initialCountry = 'EG';
  var number;

  Validations validator = Validations();
  TextEditingController mobileNumberController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  get labelText => null;
  List<Widget> NavbarPages = [ProfileEdit(), FavoriteScreen()];
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

    if (image != null) {
      imageFile = File(image.path);
    }
    // print(imageFile);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var temp = BlocProvider.of<HomeCubit>(context)
        .cacheModel!
        .usersCachedModel
        .where(
            (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);
    UserModel userModel = temp.first.cachedUser;
    fNameController.text = userModel.fName;
    lNameController.text = userModel.lName;
    emailController.text = userModel.email;
    newPasswordController.text = "";
    oldPasswordController.text = "";
    addressController.text = userModel.address;
    // number.phoneNumber=userModel.phone;
    number = PhoneNumber(phoneNumber: userModel.phone, isoCode: 'EG');
    // number=phone
    mobileNumberController.text = userModel.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !BlocProvider.of<HomeCubit>(context).isDark? kLightModeBackgroundColor : kDarkModeBackgroundColor,
      appBar: AppBar(
          backgroundColor: kAppBackgroundColor,
          leading: IconButton(onPressed: (){Navigator.pop(context);
            },icon: Icon(
            Icons.arrow_back_sharp,
            color: BlocProvider.of<HomeCubit>(context).isDark?Colors.black:Colors.white,
          ),),
          centerTitle: true,
          title: Text(
            "Edit Profile",
            style: TextStyle(color: !BlocProvider.of<HomeCubit>(context).isDark? Colors.white : Colors.black),
          )),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
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
                            border: Border.all(width: 4, color: !BlocProvider.of<HomeCubit>(context).isDark? Colors.white : Colors.black),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: !BlocProvider.of<HomeCubit>(context).isDark? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.2))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageFile != null
                                  ? FileImage(imageFile!)
                                  : BlocProvider.of<HomeCubit>(context)
                                  .cache
                                  .cachedUser
                                  .img !=
                                  ""
                                  ? NetworkImage(
                                  BlocProvider.of<HomeCubit>(context)
                                      .cache
                                      .cachedUser
                                      .img)
                                  : AssetImage("assets/profile.png")
                              as ImageProvider,
                            )),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4, color: Colors.white),
                              color: kAppBackgroundColor,
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: ()async {
                                await getImage(0);
                                setState(() {

                                });
                              },
                              icon: Icon(Icons.photo, color: Colors.white),
                            ),
                          )),
                      Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 4, color: Colors.white),
                              color: kAppBackgroundColor,
                            ),
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () async{
                                await getImage(1);
                                setState(() {

                                });
                              },
                              icon: const Icon(Icons.camera, color: Colors.white),
                            ),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTextField(
                          'Edit Your First Name',
                          fNameController,
                          validator: (String? val) {
                            return validator.validateName(val!);
                          },
                        ),
                        const SizedBox(height: 10),
                        buildTextField('Edit Your Last Name', lNameController,
                            validator: (String? val) {
                              return validator.validateName(val!);
                            }),
                        const SizedBox(height: 10),
                        buildTextField(
                          'Edit Your Email',
                          emailController,
                          validator: (String? val) {
                            return validator.validateEmail(val!);
                          },
                        ),
                        const SizedBox(height: 10),
                        buildTextField('Enter Your Current Password',
                            oldPasswordController,
                            isPassword: true),
                        const SizedBox(height: 10),
                        buildTextField(
                            'Edit Your Password', newPasswordController,
                            validator: (String? val) {
                              if ((emailController.text.isEmpty ||
                                  oldPasswordController.text.isEmpty) &&
                                  newPasswordController.text.isNotEmpty)
                                return validator.validatePassword(val!);
                              else {
                                return null;
                              }
                            }, isPassword: true),
                        const SizedBox(height: 10),
                        buildTextField('Edit Your Address', addressController,
                            validator: (String? val) {
                              return validator.validateAddress(val!);
                            }),
                        const SizedBox(height: 10),
                        InternationalPhoneNumberInput(
                          spaceBetweenSelectorAndTextField: 0,
                          onInputValidated: (value) {},
                          onInputChanged: (PhoneNumber number) {},
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          selectorTextStyle: TextStyle(color: BlocProvider.of<HomeCubit>(context).isDark? Colors.white : Colors.black),
                          initialValue: number,
                          textFieldController: mobileNumberController,
                          textStyle: TextStyle(
                            color: BlocProvider.of<HomeCubit>(context).isDark? Colors.white : Colors.black,
                          ),
                          formatInput: false,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          inputDecoration: InputDecoration(
                            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)),),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: !BlocProvider.of<HomeCubit>(context).isDark?kDarkModeTextField:kLightModeTextField,
                                width: 2,
                                style: BorderStyle.solid,),
                                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kAppBackgroundColor,
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text("SAVE",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 2,
                              color: !BlocProvider.of<HomeCubit>(context).isDark? Colors.white : Colors.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            )),
      ),
    );
  }

  Widget buildTextField(String labelText, controller,
      {validator = null, isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: !BlocProvider.of<HomeCubit>(context).isDark?kDarkModeTextField:kLightModeTextField, width: 2.0)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: !BlocProvider.of<HomeCubit>(context).isDark?kDarkModeTextField:kLightModeTextField, width: 5.0)),
        labelText: labelText,
        labelStyle: TextStyle(
          color: !BlocProvider.of<HomeCubit>(context).isDark? kLightModeTextField:kDarkModeTextField,
          fontSize: 13,
        ),
        // hintText: "Edit Your Password"
      ),
      cursorColor: kLightModeTextField,
      style: TextStyle(
        color: BlocProvider.of<HomeCubit>(context).isDark? Colors.white : Colors.black,
      ),
    );
  }
}