import 'dart:io';

import 'package:clean_arch_chat/Chat/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/get_all_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/get_single_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/search_users.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/sign_out.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/update_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/upload_image_profile.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
      {required this.uploadImage,
      required this.singleUser,
      required this.getUser,
      required this.updateUser,
      required this.signOut,
      required this.searchUserUseCases})
      : super(HomeInitial());

  final GetAllUserUseCase getUser;
  final UpdateUserUseCase updateUser;
  final HomeSignOutUseCase signOut;
  final GetSingleUserUseCase singleUser;
  final UploadImageProfileUseCase uploadImage;
  bool isVisible = true;
  bool dataLoaded = false;
  IconData suffix = Icons.visibility_outlined;

  static HomeCubit get(context) => BlocProvider.of(context);

  final SearchUserUseCases searchUserUseCases;

  List<UserEntity> usersSearch = [];

  searchUser(String userName) async {
    try {
      emit(HomeSearchLoading());
      final userStream = await searchUserUseCases(userName);
      userStream.listen((users) {
        this.usersSearch = users;
      });
      emit (HomeSearchSuccess());
    } on SocketException catch (e) {
      emit(HomeSearchError(e.toString()));
    } catch (e) {
      print(e);
      emit(HomeSearchError(e.toString()));
    }
  }

  List<UserEntity> users = [];

  getUserData() async {
    try {
      emit(HomeGetAllUserLoading());
      final userStream = await getUser.call();
      userStream.listen((users) {
        this.users = users;
        emit(HomeGetAllUserSuccess());
      });
    } on SocketException catch (e) {
      emit(HomeGetAllUserError(e.toString()));
    } catch (e) {
      emit(HomeGetAllUserError(e.toString()));
    }
  }

  updateData(Map<String, dynamic> data) async {
    try {
      emit(HomeUpdateUserLoading());
      await updateUser.call(data);
      emit(HomeUpdateUserSuccess());
    } on SocketException catch (e) {
      emit(HomeUpdateUserError(e.toString()));
    } catch (e) {
      emit(HomeUpdateUserError(e.toString()));
    }
  }

  Future<void> signOutMethod() async {
    try {
      await signOut.call();
      emit(HomeSignOut());
    } catch (e) {
      emit(HomeSignOutError(e.toString()));
    }
  }

  UserEntity? userEntity;

  getSingleUserMethod(String uId) async {
    try {
      emit(HomeGetSingleUserLoading());
      userEntity = await singleUser.call(uId);
      emit(HomeGetSingleUserSuccess());
    } on SocketException catch (e) {
      emit(HomeGetSingleUserError(e.toString()));
    } catch (e) {
      emit(HomeGetSingleUserError(e.toString()));
      rethrow;
    }
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(HomeProfileImagePickedSuccessState());
    } else {
      Utils.showSnackBar(
        'No image selected',
      );
      emit(HomeProfileImagePickedErrorState());
    }
  }

  Future<void> updateProfile({
    required String name,
    required String password,
    File? imageFile,
  }) async {
    try {
      emit(HomeUpdateUserLoading());

      final imageUrl = imageFile != null
          ? await uploadImage(imageFile)
          : userEntity!.userImage;
      await updateData({
        'name': name,
        'password': password,
        'image': imageUrl,
        'lastActive': DateTime.now(),
      });
      emit(HomeUpdateUserSuccess());
    } on SocketException catch (e) {
      emit(HomeUpdateUserError(e.toString()));
    } catch (e) {
      emit(HomeUpdateUserError(e.toString()));
    }
  }

  void changePasswordVisibility() {
    isVisible = !isVisible;
    suffix =
        isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
  }
}
