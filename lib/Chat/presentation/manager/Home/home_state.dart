part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeGetAllUserLoading extends HomeState {}
class HomeGetAllUserSuccess extends HomeState {
}
class HomeGetAllUserError extends HomeState {
  final String message;

  HomeGetAllUserError(this.message);
}

class HomeUpdateUserLoading extends HomeState {}
class HomeUpdateUserSuccess extends HomeState {
}
class HomeUpdateUserError extends HomeState {
  final String message;

  HomeUpdateUserError(this.message);
}

class HomeSignOut extends HomeState {}
class HomeSignOutError extends HomeState {
  final String message;

  HomeSignOutError(this.message);
}
class HomeGetSingleUserLoading extends HomeState {}
class HomeGetSingleUserSuccess extends HomeState {

}
class HomeGetSingleUserError extends HomeState {
  final String message;

  HomeGetSingleUserError(this.message);
}

class HomeProfileImagePickedSuccessState extends HomeState {}
class HomeProfileImagePickedErrorState extends HomeState {

}

class HomeProfileImageUploadLoadingState extends HomeState {}
class HomeProfileImageUploadErrorState extends HomeState {}