import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/auth/presentation/manager/credential/credential_cubit.dart';
import 'package:clean_arch_chat/auth/presentation/widgets/auth_row.dart';
import 'package:clean_arch_chat/utils/common/common.dart';
import 'package:clean_arch_chat/utils/constant/constant.dart';
import 'package:clean_arch_chat/utils/services/notification_services.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static final notification=NotificationServices();
  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
          const Center(child: CircularProgressIndicator());
        }
        if (state is SignUpError) {
          Utils.showSnackBar(state.message);
        }
        if (state is UploadImageError) {
          Utils.showSnackBar(state.message);
        }
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<CredentialCubit>(context);
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        height: 80,
                      ),
                      myLogo(context),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: cubit.profileImage == null
                            ? null
                            : FileImage(cubit.profileImage!),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () async {
                          await cubit.pickedImage();
                        },
                        child: Text(
                          'Choose Profile Picture',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthFormField(
                        labelText: 'User Name',
                        prefixIcon: Icons.person,
                        controller: userNameController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your user name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AuthFormField(
                        labelText: 'Email',
                        prefixIcon: Icons.email,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AuthFormField(
                        labelText: 'Password',
                        prefixIcon: Icons.lock,
                        controller: passwordController,
                        obscureText: cubit.isVisible,
                        suffixIcon: IconButton(
                            onPressed: () {
                              cubit.changePasswordVisibility();
                            },
                            icon: Icon(cubit.suffix)),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      buildMyButton(
                          height: 45.0,
                          label: 'Sign Up',
                          color: kPrimaryColor,
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (cubit.profileImage != null) {
                                await cubit
                                    .uploadImageMethod(cubit.profileImage!);
                                if (cubit.imageUrl != null) {
                                  final userEntity = UserEntity(
                                    userEmail: emailController.text,
                                    userPassword: passwordController.text,
                                    userName: userNameController.text,
                                    userImage: cubit.imageUrl!,
                                  );
                                  await cubit.signUpMethod(userEntity);
                                  await notification.requestPermission();
                                  await notification.getToken();
                                }
                              } else {
                                Utils.showSnackBar(
                                    'Please choose your profile image');
                              }
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      BuildAuthRow(
                        body: 'Already have an account?',
                        label: 'Sign In',
                        onPressed: () {
                          Navigator.pushNamed(context, '/signIn');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
