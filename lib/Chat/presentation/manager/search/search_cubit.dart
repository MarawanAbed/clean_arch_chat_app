import 'package:clean_arch_chat/Chat/domain/entities/user_entity.dart';
import 'package:clean_arch_chat/Chat/domain/usecases/search_users.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(
      this.searchUserUseCases,
      ) : super(SearchInitial());

  static SearchCubit get(context) => BlocProvider.of(context);

  final SearchUserUseCases searchUserUseCases;

  List<UserEntity>users=[];
  searchUser(String userName) async {
    try {
      emit(SearchLoading());
      final userStream=await searchUserUseCases(userName);
      userStream.listen((users) {
        this.users=users;
        emit(SearchSuccess());
      });
    }  catch (e) {
      print(e);
      emit(SearchError(e.toString()));
    }
  }
}
