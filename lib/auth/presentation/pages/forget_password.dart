import 'package:clean_arch_chat/auth/presentation/manager/credential/credential_cubit.dart';
import 'package:clean_arch_chat/auth/presentation/widgets/text_field.dart';
import 'package:clean_arch_chat/utils/constant/constant.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, state) {
        if (state is ForgetPasswordError) {
          Utils.showSnackBar(state.message);
        }
        if(state is ForgetPasswordSuccess)
        {
          Utils.showSnackBar('Check your email');
        }
        if (state is ForgetPasswordLoading) {
          const Center(child: CircularProgressIndicator());
        }
      },
      builder: (context, state) {
        var cubit=BlocProvider.of<CredentialCubit>(context);
        return Scaffold(
          body: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      myLogo(context),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Forget Password',
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Wrap(
                        children: [
                          Text(
                              'Provide your email and we will send you a link to reset your password ')
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthFormField(
                        labelText: 'email',
                        prefixIcon: Icons.email,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Email can not be empty';
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
                            cubit.forgetPasswordMethod(emailController.text);
                          }
                        },
                        child: const Text(
                          'Reset Password',
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Go back',
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
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
