import 'dart:io';

import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/auth/domain/usecases/create_user.dart';
import 'package:clean_arch_chat/auth/domain/usecases/forget_password.dart';
import 'package:clean_arch_chat/auth/domain/usecases/sign_in.dart';
import 'package:clean_arch_chat/auth/domain/usecases/sign_up.dart';
import 'package:clean_arch_chat/auth/domain/usecases/upload_image.dart';
import 'package:clean_arch_chat/utils/services/notification_services.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  CredentialCubit({
    required this.uploadImage,
    required this.signIn,
    required this.signUp,
    required this.forgetPassword,
    required this.createUser,
  }) : super(CredentialInitial());
  final UploadImageUseCase uploadImage;
  final SignInUseCase signIn;
  final SignUpUseCase signUp;
  final ForgetPasswordUseCase forgetPassword;
  final CreateUserUseCase createUser;
  bool isVisible = true;
  IconData suffix = Icons.visibility_outlined;
  static final notification=NotificationServices();

  static CredentialCubit get(context) => BlocProvider.of(context);

  signInMethod(UserEntity user) async {
    emit(SignInLoading());
    try {
      await signIn.call(user);
      await notification.requestPermission();
      await notification.getToken();
      emit(SignUpSuccess());
    } on SocketException catch (e) {
      emit(SignInError(e.toString()));
    } catch (e) {
      emit(SignInError(e.toString()));
    }
  }

  signUpMethod(UserEntity user) async {
    emit(SignInLoading());
    try {
      await signUp.call(user);
      await createUser.call(user);
      await notification.requestPermission();
      await notification.getToken();
      emit(SignUpSuccess());
    } on SocketException catch (e) {
      emit(SignUpError(e.toString()));
    } catch (e) {
      emit(SignUpError(e.toString()));
    }
  }

  forgetPasswordMethod(String email) async {
    emit(ForgetPasswordLoading());
    try {
      await forgetPassword.call(email);
      emit(ForgetPasswordSuccess());
    } on SocketException catch (e) {
      emit(ForgetPasswordError(e.toString()));
    } catch (e) {
      emit(ForgetPasswordError(e.toString()));
    }
  }

  void changePasswordVisibility() {
    isVisible = !isVisible;
    suffix =
        isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibility());
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> pickedImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(pickImageSuccess());
    } else {
      Utils.showSnackBar(
        'No image selected',
      );
      emit(pickImageError());
    }
  }

  String? imageUrl;

  Future<void> uploadImageMethod(File imageFile) async {
    try {
      emit(UploadImageLoading());
      imageUrl = await uploadImage.call(imageFile);
      emit(UploadImageSuccess());
    } on SocketException catch (e) {
      emit(UploadImageError(e.toString()));
    } catch (e) {
      emit(UploadImageError(e.toString()));
    }
  }
}
