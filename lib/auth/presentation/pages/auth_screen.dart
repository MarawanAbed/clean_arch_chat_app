import 'package:clean_arch_chat/utils/common/common.dart';
import 'package:clean_arch_chat/utils/constant/constant.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              myLogo(context),
              const SizedBox(
                height: 60,
              ),
              buildMyButton(
                height: 50.0,
                label: 'Sign In',
                color: kPrimaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, '/signIn');
                },
              ),
              const SizedBox(
                height: 30,
              ),
              buildMyButton(
                height: 50.0,
                label: 'Sign Up',
                color: kSecondaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, '/signUp');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
