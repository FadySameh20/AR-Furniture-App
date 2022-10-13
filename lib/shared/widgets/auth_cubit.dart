import 'package:firebase_auth/firebase_auth.dart';

import 'auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  void login (String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email,
        password: password).
    then((value) {
      emit(AuthSuccessfullyState());
    }).catchError((error) {
      emit(AuthErrorState());
    });
  }

}