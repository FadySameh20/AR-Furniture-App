import 'package:ar_furniture_app/shared/widgets/auth_cubit.dart';
import 'package:ar_furniture_app/shared/widgets/auth_states.dart';
import 'package:ar_furniture_app/shared/widgets/validations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../constants/constants.dart';
import 'input_text_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  bool isPasswordHidden = false;
  bool isLoading = false;
  String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
  Validations validator = Validations();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is AuthSuccessfullyState) {
            print("Registered Successfully");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Regiseterd Successfully !'),
            ));
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          } else if (state is AuthErrorState) {
            print("Error in registration");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error in registration !'),
            ));
            setState(() {
              isLoading = false;
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: kAppBackgroundColor,
                    strokeWidth: 5,
                  ))
                : Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 4.6,
                            left: MediaQuery.of(context).size.width / 3.5),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 3.45,
                        ),
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
                                                    firstNameController,
                                                hint: "First Name",
                                                prefixIconData: Icons.person,
                                                validate: (String? val) {
                                                  return validator.validateName(val!);
                                                },
                                              ),
                                              InputTextField(
                                                textController:
                                                    lastNameController,
                                                hint: "Last Name",
                                                prefixIconData: Icons.person,
                                                validate: (String? val) {
                                                  return validator.validateName(val!);
                                                },
                                              ),
                                              InputTextField(
                                                textController: emailController,
                                                hint: "Email",
                                                prefixIconData: Icons.email,
                                                validate: (String? val) {
                                                  return validator.validateEmail(val!);
                                                },
                                              ),
                                              InputTextField(
                                                textController: passController,
                                                hint: "Password",
                                                prefixIconData: Icons.password,
                                                validate: (String? val) {
                                                  return validator.validatePassword(val!);
                                                },
                                              ),
                                              InputTextField(
                                                textController:
                                                    confirmPassController,
                                                hint: "Confirm Password",
                                                prefixIconData: Icons.password,
                                                validate: (String? val) {
                                                  return validator.checkPasswordCompatability(passController.text, val!);
                                                },
                                              ),
                                              InputTextField(
                                                textController:
                                                    addressController,
                                                hint: "Address",
                                                prefixIconData:
                                                    Icons.add_location,
                                                validate: (String? val) {
                                                  return validator.validateAddress(val!);
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
                              SizedBox(
                                height: 2.0,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if(formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    BlocProvider.of<AuthCubit>(context).register(
                                        firstNameController.text,
                                        lastNameController.text,
                                        emailController.text,
                                        passController.text,
                                        addressController.text,
                                        mobileNumberController.text);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(191, 122, 47, 1),
                                ),
                                child: Text(
                                  "Register",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height > 700
                                    ? 20.0
                                    : 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Already have an account ?',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(width: 5.0),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(191, 122, 47, 1),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: ClipPath(
                          clipper: AuthClip(),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.1,
                            width: double.infinity,
                            // color: const Colors.blue,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [
                                // 234,
                                Color.fromRGBO(248, 197, 142, 1.0),

                                Color.fromRGBO(239, 169, 93, 1.0),

                                Color.fromRGBO(191, 122, 47, 1),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class AuthClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.lineTo(size.width / 2,
        0); //Make a line starting from top left of screen till down
    path.quadraticBezierTo(
        size.width / 3, size.height / 5, size.width / 2, size.height / 4);
    path.quadraticBezierTo(size.width / 1.7, size.height / 3.7,
        size.width / 1.5, size.height / 3.7);
    path.quadraticBezierTo(size.width / 1.3, size.height / 3.5,
        size.width / 1.3, size.height / 2.5);
    path.quadraticBezierTo(size.width / 1.2, size.height / 1.1,
        size.width / 0.9, size.height / 1.5);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
