import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController=TextEditingController();
  var passController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Login"),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText:"Email"
                  ),

                ),
                TextField(
                  controller:passController,
                  decoration: InputDecoration(
                    hintText:"Password"
                  ),
                  obscureText: true,
                ),
                ElevatedButton(onPressed: ()async{
                print(emailController.text);
                print(passController.text);
                await  FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passController.text).
                  then((value){
                    print("test");
                    print(value);}).catchError((error){print(error);
                    });
                  print("out");
                }, child: Text("Login"))

              ],
            ),
          ),
        ),
      )
    );
  }
}
