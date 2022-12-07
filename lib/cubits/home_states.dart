abstract class HomeState{}

class InitialHomeState extends HomeState{}

class LoadingOffersState extends HomeState{}

class SuccessOffersState extends HomeState{}

class ErrorOffersState extends HomeState{}

class AddOrRemoveFavoriteState extends HomeState{}
class LoadingMakeOrder extends HomeState{}

class UpdatePasswordSuccessState extends HomeState{}

class UpdatePasswordErrorState extends HomeState{
  String error;
  UpdatePasswordErrorState(this.error);
}

class UpdateEmailSuccessState extends HomeState{}

class UpdateEmailErrorState extends HomeState{
  String error;
  UpdateEmailErrorState(this.error);
}

class UpdateLoadingState extends HomeState{}

class UpdateUserDataSuccessData extends HomeState{}

class UpdateUserDataErrorData extends HomeState{
  String error;
  UpdateUserDataErrorData(this.error);
}

class AddedToCartSuccessfully extends HomeState{}

class OrderMadeSuccessfully extends HomeState{}

class ErrorInCheckout extends HomeState{}

class ErrorInDiscount extends HomeState{}

class UpdatedCategoriesScroller extends HomeState{}

