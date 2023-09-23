import 'dart:io';

import 'package:clean_arch_chat/Chat/presentation/manager/Home/home_cubit.dart';
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
  File? selectedImage;

  @override
  void initState() {
    final cubit = HomeCubit.get(context);
    cubit.getSingleUserMethod(FirebaseAuth.instance.currentUser!.uid);
    nameController.text = cubit.userEntity!.userName ?? '';
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeUpdateUserLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        var cubit = HomeCubit.get(context);
        final userImageProvider = cubit.profileImage != null
            ? FileImage(cubit.profileImage!)
            : NetworkImage(cubit.userEntity!.userImage!);
        return Padding(
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
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                ),
                child: MaterialButton(
                  onPressed: () {
                    _updateProfile(context);
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateProfile(BuildContext context) async {
    final cubit = HomeCubit.get(context);
    final userName = nameController.text;

    if (userName.isNotEmpty) {
      if (cubit.profileImage != null) {
        // Update the profile with the selected image and name
        await cubit.updateProfile(
            name: userName, imageFile: cubit.profileImage!);
      } else {
        // No new image selected, update the user's profile without changing the image
        await cubit.updateData({
          'name': userName,
        });
      }
    }
  }
}
