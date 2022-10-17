import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:ar_furniture_app/models/offers_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit():super(InitialHomeState());

  List<Offers> offers=[];

  void getoffers() async {
    await FirebaseFirestore.instance.collection('offer')
        .get().then((value){
          value.docs.forEach((element) {
            offers.add(Offers.fromJson(element.data()));
          });
    });
    print(offers.length);

  }

}