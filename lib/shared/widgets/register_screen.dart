import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Material(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(hintText: "Email"),
                          validator: (value) {
                            if (value!.isEmpty) return "You entered nothing";
                          },
                        ),
                        TextField(
                          controller: passController,
                          decoration: InputDecoration(hintText: "Password"),
                          obscureText: true,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              print(emailController.text);
                              print(passController.text);
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passController.text)
                                  .then((value) {
                                print("test");
                                print(value);
                              }).catchError((error) {
                                print(error);
                              });
                              print("out");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(191, 122, 47, 1),
                            ),
                            child: Text(
                              "Register",
                              style: TextStyle(fontSize: 18),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom:10,
              child: Row(
                children: <Widget>[
                  Text(
                    'Already have an account ?',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Color.fromRGBO(191, 122, 47, 1),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 18),
                    ),
                  ),

                ],
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
        ));
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
