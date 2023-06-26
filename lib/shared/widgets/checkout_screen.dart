import 'dart:convert';

import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:ar_furniture_app/shared/widgets/cart_screen.dart';
import 'package:ar_furniture_app/shared/widgets/circle_avatar.dart';
import 'package:ar_furniture_app/shared/widgets/validations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../models/furniture_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'input_text_field.dart';

class CheckoutScreen extends StatefulWidget {
  // List<FurnitureModel> furnitureList;
  // CartScreen({required this.furnitureList});

  // late List<FurnitureModel> furnitureList;
  Map<String, dynamic> cartMap;
  double subTotal;

  CheckoutScreen({required this.subTotal, required this.cartMap});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController appartmentNumberController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController buildingNumberController = TextEditingController();
  TextEditingController floorNumberController = TextEditingController();
  TextEditingController streetNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  var number =PhoneNumber(isoCode: 'EG');
  Validations validator = Validations();
  var formKey = GlobalKey<FormState>();

  double tax = 0;
  double totalPrice = 0;
  double estimatingTax = 0.14;

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // await this.setCache();
      tax = widget.subTotal * estimatingTax;
      totalPrice = widget.subTotal + tax;
      // setCartData();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(listener: (context, state) {
      if (state is ErrorInCheckout) {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "Unavailable Quantity",
          desc: BlocProvider.of<HomeCubit>(context)
              .unavailableQuantityFurniture
              .join('\n\n'),
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: kAppBackgroundColor,
            ),
          ],
          style: AlertStyle(
            animationType: AnimationType.fromTop,
            animationDuration: Duration(milliseconds: 400),
            titleStyle: TextStyle(
              color: Colors.red,
            ),
            descStyle: TextStyle(
              fontSize: 17,
            ),
          ),
        ).show();
      } else if (state is ErrorInDiscount) {
          Alert(
            context: context,
            type: AlertType.warning,
            title: "Discount has changed",
            desc: BlocProvider.of<HomeCubit>(context)
                .changedDiscountList
                .join('\n\n'),
            buttons: [
              DialogButton(
                child: Text(
                  "Return to cart screen",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>CartScreen(furnitureList: BlocProvider.of<HomeCubit>(context).furnitureList, cartMap: BlocProvider.of<HomeCubit>(context).cache.cartMap)));
                },
                color: kAppBackgroundColor,
              ),
            ],
            style: AlertStyle(
              animationType: AnimationType.fromTop,
              animationDuration: Duration(milliseconds: 400),
              titleStyle: TextStyle(
                color: Colors.red,
              ),
              descStyle: TextStyle(
                fontSize: 17,
              ),
            ),
          ).show();
      } else if (state is OrderMadeSuccessfully) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Placed order successfully !'),
        ));
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: !BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(191, 122, 47, 1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: !BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Checkout",
            style: TextStyle(color: !BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black),
          ),
        ),

        // height: MediaQuery.of(context).size.height * 0.6,
        // flex: 2,
        body: SingleChildScrollView(
          child: Column(
              children: [
            Container(
                padding: EdgeInsets.only(left: 15, top: 20, right: 15),
                child: Container(
                  child: Form(
                    key: formKey,
                    child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTextField(
                            'Area',
                            areaController,
                            validator: (String? val) {
                              return validator.validateText(val!);
                            },
                          ),
                          SizedBox(height: 10),
                          buildTextField('Street Name', streetNameController,
                              validator: (String? val) {
                            return validator.validateText(val!);
                          }),
                          SizedBox(height: 10),
                          buildTextField(
                            'building Number',
                            buildingNumberController,
                            validator: (String? val) {
                              return validator.validateNumber(val!);
                            },
                          ),
                          SizedBox(height: 10),
                          buildTextField('Floor Number', floorNumberController,
                            validator: (String? val) {
                              return validator.validateNumber(val!);
                            },),

                          SizedBox(height: 10),
                          buildTextField(
                            'Appartment Number',
                            appartmentNumberController,
                            validator: (String? val) {
                              return validator.validateNumber(val!);
                            },
                          ),
                          SizedBox(height: 10),
                          InternationalPhoneNumberInput(

                            textStyle:TextStyle(color: BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black),
                            spaceBetweenSelectorAndTextField: 0,
                            onInputValidated: (value) {},
                            onInputChanged: (PhoneNumber number) {},
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.onUserInteraction,

                            selectorTextStyle:
                         TextStyle(color: BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black),
                            initialValue: number,
                            textFieldController: mobileNumberController,
                            formatInput: false,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            inputBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                        ]),
                  ),
                ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.07,),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                color: !BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sub Total            ",style:TextStyle(color: BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black)),
                          Text("\EGP ${widget.subTotal.toStringAsFixed(2)}",style:TextStyle(color: BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Estimating Tax(14%)            ",style:TextStyle(color: BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black)),
                          Text("\EGP ${tax.toStringAsFixed(2)}",style:TextStyle(color: BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black)),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.05,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",style:TextStyle(color: BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black)),
                          Text("\EGP ${totalPrice.toStringAsFixed(2)}",style:TextStyle(color: BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black)),
                        ],
                      ),
                      SizedBox(
                        height:MediaQuery.of(context).size.height*0.025,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: state is LoadingMakeOrder?Center(child: CircularProgressIndicator(),): ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10),
                                    backgroundColor:
                                        Color.fromRGBO(191, 122, 47, 1),
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {});
                                      // await BlocProvider.of<AuthCubit>(context).register(
                                      //      firstNameController.text,
                                      //      lastNameController.text,
                                      //      emailController.text,
                                      //      passController.text,
                                      //      addressController.text,
                                      //      mobileNumberController.text
                                      // imgController.text);

                                      await BlocProvider.of<HomeCubit>(context)
                                          .checkAvailableFurnitureQuantity(
                                          appartmentNumberController.text,
                                          areaController.text,
                                          buildingNumberController.text,
                                          floorNumberController.text,
                                          mobileNumberController.text,
                                          streetNameController.text);
                                    }

                                  },
                                  child: Text(
                                    "Place Order",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
 color: !BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black,
                                        fontSize: 20),
                                  ))),
                        ],
                      )
                    ],
                  ),
                )),
          ],
          ),
        ),
       );
    });
  }

  Widget buildTextField(String labelText, controller,
      {validator = null, isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      style: TextStyle(color: BlocProvider.of<HomeCubit>(context).isDark?Colors.white:Colors.black),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromRGBO(214, 189, 169, 1), width: 2.0)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromRGBO(157, 139, 124, 1), width: 5.0)),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Color.fromRGBO(124, 58, 40, 1),
          fontSize: 13,
        ),

        // hintText: "Edit Your Password"
      ),
      cursorColor: Color.fromRGBO(124, 58, 40, 1),
    );
  }
}
