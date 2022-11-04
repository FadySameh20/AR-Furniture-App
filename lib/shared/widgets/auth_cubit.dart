import 'package:ar_furniture_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      String password, String address, String mobileNumber,String img) async {
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
              email: email
          );
          await FirebaseFirestore.instance
              .collection('user')
              .doc(userId)

              .set(registeredUser.toMap())
              .then((value) => emit(AuthSuccessfullyState()))
              .catchError((error) {
                print(error);
                emit(AuthErrorState());});
    }).catchError((error) {
      print(error);
      emit(AuthErrorState());
    });
    
  }
}
