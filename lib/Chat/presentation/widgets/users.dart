import 'package:clean_arch_chat/Chat/presentation/manager/Home/home_cubit.dart';
import 'package:clean_arch_chat/Chat/presentation/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Users extends StatefulWidget {
  const Users({
    super.key,
  });

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  bool _dataLoaded = false; // Add this flag

  @override
  void initState() {
    final cubit = HomeCubit.get(context);

    // Check if data has already been loaded
    if (!_dataLoaded) {
      cubit.getUserData();
      _dataLoaded = true; // Set the flag to true after loading data
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = HomeCubit.get(context);

        if (state is HomeGetAllUserLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is HomeGetAllUserError) {
          return const Center(
            child: Text('Error'),
          );
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => UserItem(
                  userEntity: cubit.users[index],
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: cubit.users.length,
              ),
            ],
          ),
        );
      },
    );
  }
}
