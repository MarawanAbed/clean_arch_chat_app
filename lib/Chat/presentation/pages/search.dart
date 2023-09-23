import 'package:clean_arch_chat/Chat/domain/usecases/search_users.dart';
import 'package:clean_arch_chat/Chat/presentation/manager/search/search_cubit.dart';
import 'package:clean_arch_chat/Chat/presentation/widgets/user_item.dart';
import 'package:clean_arch_chat/utils/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(sl<SearchUserUseCases>()),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          var cubit = SearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Search'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      cubit.searchUser(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  cubit.users.isEmpty
                      ? const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search, size: 100, color: Colors.grey),
                              Text('Not Found'),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return UserItem(
                                userEntity: cubit.users[index],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            itemCount: cubit.users.length,
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
