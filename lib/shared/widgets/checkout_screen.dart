import 'dart:convert';

import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/shared/cache/sharedpreferences.dart';
import 'package:ar_furniture_app/shared/constants/constants.dart';
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
  TextEditingController floorNumberController  = TextEditingController();
  TextEditingController streetNameController  = TextEditingController();
  TextEditingController mobileNumberController  = TextEditingController();
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
    return BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if(state is ErrorInCheckout) {
            Alert(
              context: context,
              type: AlertType.warning,
              title: "Unavailable Quantity",
              desc: BlocProvider.of<HomeCubit>(context).unavailableQuantityFurniture.join('\n\n'),
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
          } else if(state is CheckoutSuccessfully) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('PLaced order successfully !'),
            ));
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(191, 122, 47, 1),
              title: Text(
                "Checkout",
                style: TextStyle(),
              ),
            ),

            // height: MediaQuery.of(context).size.height * 0.6,
            // flex: 2,
            body: Stack(
              children: [
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.all(30.0),
                            height:
                            MediaQuery.of(context).size.height / 2,
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  key: formKey,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        InputTextField(
                                          textController:
                                          areaController,
                                          hint: "Area",
                                          prefixIconData: Icons.person,
                                          validate: (String? val) {
                                            return validator.validateText(val!);
                                          },
                                        ),
                                        InputTextField(
                                          textController: streetNameController,
                                          hint: "Street Name",
                                          prefixIconData: Icons.password,
                                          validate: (String? val) {
                                            return validator.validateText(val!);
                                          },
                                        ),
                                        InputTextField(
                                          textController:
                                          buildingNumberController,
                                          hint: "Building Number",
                                          prefixIconData: Icons.person,
                                          validate: (String? val) {
                                            return validator.validateText(val!);
                                          },
                                        ),
                                        InputTextField(
                                          textController: floorNumberController,
                                          hint: "floor Number",
                                          prefixIconData: Icons.email,
                                          validate: (String? val) {
                                            return validator.validateText(val!);
                                          },
                                        ),

                                        InputTextField(
                                          textController:
                                          appartmentNumberController,
                                          hint: "Appartment Number",
                                          prefixIconData: Icons.password,
                                          validate: (String? val) {
                                            return validator.validateText(val!);
                                          },
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 13.0,
                                              bottom: 12.0,
                                              left: 12.0,
                                              right: 8.0),
                                          child:

                                          InternationalPhoneNumberInput(
                                            spaceBetweenSelectorAndTextField:
                                            0,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),








                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30)),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Sub Total            "),
                                  Text("\EGP ${widget.subTotal.toStringAsFixed(2)}"),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text("Shipping fee    "),
                              //     Text('\EGP 300'),
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Estimating Tax(14%)            "),
                                  Text("\EGP ${tax.toStringAsFixed(2)}"),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total"),
                                  Text("\EGP ${totalPrice.toStringAsFixed(2)}"),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            backgroundColor:
                                            Color.fromRGBO(191, 122, 47, 1),
                                          ),
                                          onPressed: () async {
                                            if(formKey.currentState!.validate()) {
                                              setState(() {

                                              });
                                              // await BlocProvider.of<AuthCubit>(context).register(
                                              //      firstNameController.text,
                                              //      lastNameController.text,
                                              //      emailController.text,
                                              //      passController.text,
                                              //      addressController.text,
                                              //      mobileNumberController.text
                                              // imgController.text);
                                            }
                                            await BlocProvider.of<HomeCubit>(context).checkAvailableFurnitureQuantity(appartmentNumberController.text, areaController.text, buildingNumberController.text, floorNumberController.text, mobileNumberController.text, streetNameController.text);
                                          },
                                          child: Text(
                                            "Place Order",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ))),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                )
              ],
            ),
          );
        });
  }
}
