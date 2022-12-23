import 'dart:io';

import 'package:ar_furniture_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/user_model.dart';
import 'auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(AuthSuccessfullyState());
    }).catchError((error) {
      emit(AuthErrorState());
    });
  }

  register(String firstName, String lastName, String email,
      String password, String address, String mobileNumber,{File? image}) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      UserModel registeredUser = UserModel(
          fName: firstName,
          lName: lastName,
          phone: mobileNumber,
          address: address,
          uid: userId,
          email: email,img:"");
      if(image!=null){
        print("hello");
        final ref=FirebaseStorage.instance.ref().child("users/$userId.${image.path.split(".").last}");
        await ref.putFile(image);
        final url= await ref.getDownloadURL();
        registeredUser.img=url;
      }
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .set(registeredUser.toMap())
          .then((value) => emit(AuthSuccessfullyState()))
          .catchError((e) {
       emit(AuthErrorState());});
    }).catchError((e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        emit(WeakPasswordState());
        return;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        emit(EmailAlreadyInUse());
        return;
      }
      emit(AuthErrorState());
    });

  }
}
