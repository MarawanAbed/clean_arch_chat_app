import 'dart:async';
import 'package:clean_arch_chat/auth/domain/usecases/is_email_verified.dart';
import 'package:clean_arch_chat/auth/domain/usecases/send_email_verification.dart';
import 'package:clean_arch_chat/auth/domain/usecases/sign_out.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'verify_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit(
      {required this.signOut ,required this.isEmailVerification, required this.sendEmailVerification})
      : super(VerificationInitial());
  final IsEmailVerificationUseCase isEmailVerification;
  final SendEmailVerificationUseCase sendEmailVerification;
  final SignOutUseCase signOut;
  Timer? emailVerificationTimer;

  Future<void> sendVerificationEmail() async {
    try {
      await sendEmailVerification.call();
      print('Email verification email sent.');
      startEmailVerificationTimer();
    } catch (e) {
      emit(VerificationError(e.toString()));
    }
  }

  void startEmailVerificationTimer() {
    print('Starting email verification timer.');
    emailVerificationTimer?.cancel(); // Cancel any existing timer.
    emailVerificationTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );
  }

  void checkEmailVerified() async {
    print('Checking email verification status.');
      final isVerified=await isEmailVerification.call();
    if (isVerified) {
      emit(VerificationSuccess());
      print('Email is verified. Cancelling timer.');
      emailVerificationTimer?.cancel();
    }
  }

  Future<void> signOutMethod() async {
    try {
      await signOut.call();
      emit(VerificationSignOut());
    } catch (e) {
      emit(VerificationError(e.toString()));
    }
  }
  @override
  Future<void> close() {
    emailVerificationTimer?.cancel();
    return super.close();
  }
}
