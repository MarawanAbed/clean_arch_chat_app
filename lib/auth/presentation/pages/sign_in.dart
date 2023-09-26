import 'package:clean_arch_chat/auth/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/auth/presentation/manager/credential/credential_cubit.dart';
import 'package:clean_arch_chat/auth/presentation/widgets/auth_row.dart';
import 'package:clean_arch_chat/utils/common/common.dart';
import 'package:clean_arch_chat/utils/constant/constant.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, state) {
        if (state is SignInError) {
          Utils.showSnackBar(state.message);
        }
        if (state is SignInLoading) {
          const Center(child: CircularProgressIndicator());
        }
      },
      builder: (context, state) {
        var cubit = CredentialCubit.get(context);
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
                        'Sign In',
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
                        obscureText: cubit.isVisible,
                        controller: passwordController,
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
                        label: 'Sign In',
                        color: kPrimaryColor,
                        onPressed: ()async {
                          if (formKey.currentState!.validate()) {
                            cubit.signInMethod(UserEntity(
                              userEmail: emailController.text,
                              userPassword: passwordController.text,
                            ));
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(""),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forgetPassword');
                            },
                            child: Text(
                              'Forget Password ?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                      BuildAuthRow(
                        label: 'Sign In',
                        body: 'Don\'t have an account?',
                        onPressed: () {
                          Navigator.pushNamed(context, '/signUp');
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
