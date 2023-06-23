import 'package:ar_furniture_app/cubits/home_cubit.dart';
import 'package:ar_furniture_app/shared/constants/constants.dart';
import 'package:ar_furniture_app/shared/widgets/auth_cubit.dart';
import 'package:ar_furniture_app/shared/widgets/auth_states.dart';
import 'package:ar_furniture_app/shared/widgets/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'input_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  bool isPasswordHidden = true;
  bool isLoading = false;
  Validations validator = Validations();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) async {
          if (state is AuthSuccessfullyState) {
            print("Logged In Successfully");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Logged In Successfully !'),
            ));
            await BlocProvider.of<HomeCubit>(context).setCache();
            await BlocProvider.of<HomeCubit>(context).updateFavoriteList();
            await BlocProvider.of<HomeCubit>(context).updateCart();
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          } else if (state is AuthErrorState) {
            print("Error in login");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Incorrect email or password !'),
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
                            top: MediaQuery.of(context).size.height / 4.25),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.all(30.0),
                                  height:
                                      MediaQuery.of(context).size.height / 4,
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
                                                textController: emailController,
                                                hint: "Email",
                                                prefixIconData: Icons.email,
                                                validate: (String? val) {
                                                  return validator
                                                      .validateEmail(val!);
                                                },
                                              ),
                                              InputTextField(
                                                textController: passController,
                                                hint: "Password",
                                                prefixIconData: Icons.password,
                                                validate: (String? val) {
                                                  return validator
                                                      .validatePassword(val!);
                                                },
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
                                height: 30.0,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await BlocProvider.of<AuthCubit>(context)
                                        .login(emailController.text,
                                            passController.text);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kAppBackgroundColor,
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'Create a new account ?',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 5.0),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                          color: kAppBackgroundColor,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          fontSize: 18
                                      ),
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

                                kAppBackgroundColor,
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
