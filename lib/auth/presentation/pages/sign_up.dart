import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/auth/presentation/manager/credential/credential_cubit.dart';
import 'package:clean_arch_chat/auth/presentation/widgets/text_field.dart';
import 'package:clean_arch_chat/utils/constant/constant.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var emailController = TextEditingController();

  var userNameController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();
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
                        suffixIcon: IconButton(onPressed: (){
                          cubit.changePasswordVisibility();
                        }, icon: Icon(cubit.suffix)),
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
                      MaterialButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            cubit.signUpMethod(
                              UserEntity(
                                userPassword: passwordController.text,
                                userName: userNameController.text,
                                userEmail: emailController.text,
                                userImage:
                                    'https://image.flaticon.com/icons/png/512/147/147144.png',
                                userLastActive: DateTime.now(),
                                userIsOnline: true,
                              ),
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        color: kPrimaryColor,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign Up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'have an account? ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signIn');
                            },
                            child: Text(
                              'Sign In ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
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
