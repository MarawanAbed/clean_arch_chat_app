import 'dart:io';

import 'package:clean_arch_chat/Chat/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/get_all_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/get_single_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/sign_out.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/update_user.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/upload_image_profile.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.uploadImage,
    required this.singleUser,
    required this.getUser,
    required this.updateUser,
    required this.signOut,
  }) : super(HomeInitial());

  final GetAllUserUseCase getUser;
  final UpdateUserUseCase updateUser;
  final HomeSignOutUseCase signOut;
  final GetSingleUserUseCase singleUser;
  final UploadImageProfileUseCase uploadImage;

  static HomeCubit get(context) => BlocProvider.of(context);

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

  updateData(UserEntity user) async {
    try {
      emit(HomeUpdateUserLoading());
      await updateUser.call(user);
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
    File? imageFile,
  }) async {
    try {
      emit(HomeUpdateUserLoading());

      final imageUrl = imageFile != null ? await uploadImage(imageFile) : userEntity!.userImage;

      final updatedUser = UserEntity(
        userName: name,
        userImage: imageUrl,
        userUId: userEntity!.userUId,
        userEmail: userEntity!.userEmail,
        userPassword: userEntity!.userPassword,
        userIsOnline: true,
        userLastActive: DateTime.now(),
      );

      await updateUser.call(updatedUser);
      emit(HomeUpdateUserSuccess());
    } on SocketException catch (e) {
      emit(HomeUpdateUserError(e.toString()));
    } catch (e) {
      emit(HomeUpdateUserError(e.toString()));
    }
  }
}
