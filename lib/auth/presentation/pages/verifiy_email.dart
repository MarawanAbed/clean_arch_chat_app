import 'package:clean_arch_chat/Chat/presentation/pages/home.dart';
import 'package:clean_arch_chat/auth/domain/usecases/is_email_verified.dart';
import 'package:clean_arch_chat/auth/domain/usecases/send_email_verification.dart';
import 'package:clean_arch_chat/auth/domain/usecases/sign_out.dart';
import 'package:clean_arch_chat/auth/presentation/manager/credential/verify/verify_cubit.dart';
import 'package:clean_arch_chat/utils/constant/constant.dart';
import 'package:clean_arch_chat/utils/services/services_locator.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VerificationCubit(
          signOut: sl<SignOutUseCase>(),
          isEmailVerification: sl<IsEmailVerificationUseCase>(),
          sendEmailVerification: sl<SendEmailVerificationUseCase>())
        ..sendVerificationEmail(),
      child: const VerifyEmailScreen(),
    );
  }
}

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<VerificationCubit>(context);
    return Scaffold(
      body: BlocBuilder<VerificationCubit, VerificationState>(
        builder: (context, state) {
          if (state is VerificationSuccess) {
            return const HomeScreen();
          } else if (state is VerificationError) {
            // Render UI when an error occurs.
            return Utils.showSnackBar(state.errorMessage);
          } else {
            // Default UI.
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myLogo(context),
                    const SizedBox(height: 30),
                    const Text(
                      'A verification email has been sent to your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        cubit.sendVerificationEmail();
                      },
                      icon: const Icon(Icons.email),
                      label: const Text(
                        'Resend Email',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        cubit.signOutMethod();
                        Navigator.of(context)
                            .pop(); // Navigate back to the previous screen.
                      },
                      icon: const Icon(Icons.close),
                      label: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
