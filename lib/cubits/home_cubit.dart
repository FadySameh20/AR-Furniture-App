import 'package:ar_furniture_app/cubits/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState>{
  HomeCubit():super(InitialHomeState());

}