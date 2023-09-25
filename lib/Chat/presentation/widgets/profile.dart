import 'dart:io';

import 'package:clean_arch_chat/Chat/presentation/manager/Home/home_cubit.dart';
import 'package:clean_arch_chat/utils/common/common.dart';
import 'package:clean_arch_chat/utils/constant/constant.dart';
import 'package:clean_arch_chat/utils/services/show_snack_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  File? selectedImage;

  @override
  void initState() {
    final cubit = HomeCubit.get(context);
    cubit.getSingleUserMethod(FirebaseAuth.instance.currentUser!.uid);
    nameController.text = cubit.userEntity!.userName ?? '';
    emailController.text = cubit.userEntity!.userEmail ?? '';
    passwordController.text = cubit.userEntity!.userPassword ?? '';
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeUpdateUserLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is HomeUpdateUserError) {
          return Utils.showSnackBar(state.message);
        }
        if (state is HomeGetSingleUserError) {
          return Utils.showSnackBar(state.message);
        }
        var cubit = HomeCubit.get(context);
        final userImageProvider = cubit.profileImage != null
            ? FileImage(cubit.profileImage!)
            : NetworkImage(cubit.userEntity!.userImage!);
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: userImageProvider as ImageProvider<Object>?,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    cubit.getProfileImage();
                  },
                  child: const Text(
                    'Change Profile Picture',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // TextField(
                //   controller: nameController,
                //   keyboardType: TextInputType.name,
                //   decoration: const InputDecoration(
                //     labelText: 'Name',
                //     prefixIcon: Icon(Icons.person),
                //     border: OutlineInputBorder(),
                //   ),
                // ),
                AuthFormField(
                  labelText: 'Name',
                  prefixIcon: Icons.person,
                  controller: nameController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 20,
                ),
                AuthFormField(
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: cubit.isVisible,
                  suffixIcon: IconButton(
                    onPressed: () {
                      cubit.changePasswordVisibility();
                    },
                    icon: Icon(
                      cubit.isVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                buildMyButton(
                  label: 'Update Profile',
                  color: kPrimaryColor,
                  onPressed: () {
                    _updateProfile(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateProfile(BuildContext context) async {
    final cubit = HomeCubit.get(context);
    final userName = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    final isNewImageSelected = cubit.profileImage != null;

    if (userName.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      if (isNewImageSelected) {
        // Update the profile with the selected image and name
        await cubit.updateProfile(
          name: userName,
          imageFile: cubit.profileImage!,
          password: password,
        );
      } else {
        if (password.isNotEmpty) {
          try {
            // Update the user's password
            await FirebaseAuth.instance.currentUser!.updatePassword(password);
            print('Password updated successfully');
          } catch (e) {
            // Handle password update error
            Utils.showSnackBar('Password update failed: $e');
          }
        }
      }
      await cubit.updateData({
        'name': userName,
        'password': password,
        'lastActive': DateTime.now(),
      });
    } else {
      Utils.showSnackBar('Please enter your data');
    }
  }
}
